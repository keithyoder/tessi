require 'cobranca/retorno_240'

class Retorno < ApplicationRecord
  belongs_to :pagamento_perfil
  has_many :faturas
  has_many :registros, class_name: :Fatura, foreign_key: :registro_id
  has_many :baixas, class_name: :Fatura, foreign_key: :baixa_id 
  has_one_attached :arquivo

  def verificar_header
    case pagamento_perfil.tipo
    when "Boleto"
      case pagamento_perfil.banco
      when 33
        data_file = File.readlines(ActiveStorage::Blob.service.path_for(arquivo.key))
        header = Retorno240Header.load_line data_file.first
        puts header.convenio
        if header.convenio.to_i == pagamento_perfil.cedente
          self.attributes = {
            sequencia: header.sequencia,
            data: cnab_to_date(header.data),
          }
          self.save
        else
          raise StandardError.new "Arquivo não é compatível com o convênio selecionado"
        end
      when 1
      when 104
      end
    when "Débito Automático"
    end
  end

  def processar
    verificar_header
    Brcobranca::Retorno::Cnab240::Santander.load_lines(ActiveStorage::Blob.service.path_for(arquivo.key)).each do |linha|
      fatura = Fatura.where(
        pagamento_perfil: pagamento_perfil,
        nossonumero: cnab_to_nosso_numero(linha.nosso_numero),
      ).first
      puts fatura.to_s
      if fatura.present?
        case linha.codigo_ocorrencia.to_i
        when 6
          # titulo liquidado
          desconto = [0, cnab_to_float(linha.valor_recebido) - fatura.valor].min
          fatura.attributes = {
            liquidacao: cnab_to_date(linha.data_ocorrencia),
            juros_recebidos: cnab_to_float(linha.juros_mora),
            banco: linha.banco_recebedor,
            desconto_concedido: desconto,
            agencia: linha.agencia_recebedora_com_dv[0...-1],
            valor_liquidacao: cnab_to_float(linha.valor_recebido),
            meio_liquidacao: :RetornoBancario,
            retorno: self,
          }
        when 2
          # titulo registrado
          fatura.attributes = {
            registro: self
          }
        when 9
          # titulo baixado manualmente
          fatura.attributes = {
            baixa: self
          }
        end
        fatura.save
      end
    end
  end

  def cnab_to_float(s)
    s.to_f / 100
  end

  def cnab_to_currency(s)
    number_to_currency(s.to_f / 100)
  end

  def cnab_to_date(s)
    Date.strptime(s, "%d%m%y")
  end

  def cnab_to_nosso_numero(s)
    #remove leading zeros and trailing digit
    s.sub!(/^[0]+/, "")[0...-1]
  end
end
