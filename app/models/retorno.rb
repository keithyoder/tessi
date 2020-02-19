require "parseline"

class RetornoHeader
  attr_accessor :sequencia
  attr_accessor :data
  attr_accessor :convenio
  attr_accessor :banco

  extend ParseLine::FixedWidth

  fixed_width_layout do |parse|
    parse.field :banco, 0..2
    parse.field :convenio, 52..62
    parse.field :data, 143..150
    parse.field :sequencia, 157..162
  end
end

class Retorno < ApplicationRecord
  belongs_to :pagamento_perfil
  has_many :faturas
  has_one_attached :arquivo

  def processar
    path = ActiveStorage::Blob.service.path_for(arquivo.key)
    data_file = File.readlines(path)
    header = RetornoHeader.load_line data_file.first
    if header.convenio.to_i == pagamento_perfil.cedente
      self.attributes = {
        sequencia: header.sequencia,
        data: cnab_to_date(header.data),
      }
      self.save
    else
      raise StandardError.new "Arquivo não é compatível com o convênio selecionado"
    end
    Brcobranca::Retorno::Cnab240::Santander.load_lines(path).each do |linha|
      if linha.codigo_ocorrencia.to_i == 6
        fatura = Fatura.where(
          pagamento_perfil: pagamento_perfil,
          nossonumero: cnab_to_nosso_numero(linha.nosso_numero),
        ).first
        if fatura.present?
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
          fatura.save
        end
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
