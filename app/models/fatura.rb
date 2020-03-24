require 'digest'

class Fatura < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :contrato
  belongs_to :pagamento_perfil
  belongs_to :retorno, optional: true
  belongs_to :registro, class_name: :Retorno, optional: true
  belongs_to :baixa, class_name: :Retorno, optional: true
  has_one :pessoa, through: :contrato
  has_one :logradouro, through: :pessoa
  has_one :bairro, through: :logradouro
  has_one :cidade, through: :bairro
  has_one :estado, through: :cidade
  has_one :plano, through: :contrato
  paginates_per 18
  scope :inadimplentes, -> { where("liquidacao is null and vencimento < ?", 5.days.ago) }
  scope :suspensos, -> { where("liquidacao is null and vencimento < ?", 15.days.ago) }
  enum meio_liquidacao: { :RetornoBancario => 1, :Dinheiro => 2, :Cheque => 3, :CartaoCredito => 4, :Outros => 5 }

  after_update do
    if saved_change_to_liquidacao?
      contrato.conexoes.update_all inadimplente: contrato.faturas_em_atraso(5) > 0
      contrato.conexoes.update_all bloqueado: contrato.faturas_em_atraso(15) > 0
    end
  end

  def remessa
    Brcobranca::Remessa::Pagamento.new(valor: valor,
      data_vencimento: vencimento,
      nosso_numero: nossonumero,
      documento_sacado: pessoa.cpf_cnpj,
      nome_sacado: pessoa.nome,
      endereco_sacado: logradouro.nome + ', ' + pessoa.numero + ' ' + pessoa.complemento,
      bairro_sacado: bairro.nome,
      cep_sacado: logradouro.cep,
      cidade_sacado: cidade.nome,
      uf_sacado: estado.sigla,
      valor_desconto: plano.desconto,
      data_desconto: vencimento)
  end

  def boleto
    info = {
      :convenio => pagamento_perfil.cedente,
      :cedente => Setting.razao_social,
      :documento_cedente => Setting.cnpj,
      :sacado => pessoa.nome,
      :sacado_documento => pessoa.cpf_cnpj,
      :valor => valor,
      :agencia => pagamento_perfil.agencia,
      :conta_corrente => pagamento_perfil.conta,
      :carteira => pagamento_perfil.carteira,
      :variacao => 'COB',
      :especie_documento => 'DS',
      :nosso_numero => nossonumero,
      :data_vencimento => vencimento,
      :instrucao1 => "Desconto de #{number_to_currency(contrato.plano.desconto)} para pagamento até o dia #{I18n.l(vencimento)}",
      :instrucao2 => "Mensalidade de Internet - SCM - Plano: #{contrato.plano.nome}",
      :instrucao3 => "Período de referência: #{I18n.l(periodo_inicio)} - #{I18n.l(periodo_fim)}",
      :instrucao4 => "Após o vencimento cobrar multa de #{Setting.multa.to_f*100}% e juros de #{Setting.juros.to_f*100}% ao mês (pro rata die)",
      :instrucao5 => "S.A.C 0800-725-2129 - sac.tessi.com.br",
      :instrucao6 => "Central de Atendimento da Anatel 1331 ou 1332 para Deficientes Auditivos.",
      :sacado_endereco => pessoa.endereco + ' - ' + pessoa.bairro.nome_cidade_uf,
      :cedente_endereco => "Rua Treze de Maio, 5B - Centro - Pesqueira - PE 55200-000"
    }
    case pagamento_perfil.banco
    when 33
      Brcobranca::Boleto::Santander.new(info)
    when 1
      Brcobranca::Boleto::BancoBrasil.new(info)
    else
      nil
    end
  end

  def base_calculo_icms
    valor_liquidacao - (juros_recebidos.nil? ? 0 : juros_recebidos)
  end

  def aliquota
    0
  end

  def valor_icms
    base_calculo_icms * aliquota
  end

  def cfop
    5307
  end

  def icms_mestre
    # Nº CONTEÚDO           TAM. POSIÇÃO FORMATO
    # 01 CNPJ ou CPF        14    1 14    N
    # 02 IE                 14    15 28   X
    # 03 Razão Social       35    29 63   X
    # 04 UF                 2     64 65   X
    # 05 Classe de Consumo  1     66 66   N
    # 06 Fase ou Tipo de Utilização 1 67 67 N
    # 07 Grupo de Tensão    2     68 69   N
    # 08 Código de Identificação do consumidor ou assinante 12 70 81 X
    # 09 Data de emissão    8     82 89   N
    # 10 Modelo             2 90 91 N
    # 11 Série              3 92 94 X
    # 12 Número             9 95 103 N
    # 13 Código de Autenticação Digital do documento fiscal 32 104 135 X
    # 14 Valor Total (com 2 decimais) 12 136 147 N
    # 15 BC ICMS (com 2 decimais) 12 148 159 N
    # 16 ICMS destacado (com 2 decimais) 12 160 171 N
    # 17 Operações isentas ou não tributadas (com 2 decimais) 12 172 183 N
    # 18 Outros valores (com 2 decimais) 12 184 195 N
    # 19 Situação do documento 1 196 196 X
    # 20 Ano e Mês de referência de apuração 4 197 200 N
    # 21 Referência ao item da NF 9 201 209 N
    # 22 Número do terminal telefônico ou da unidade consumidora 12 210 221 X
    # 23 Indicação do tipo de informação contida no campo 1 1 222 222 N
    # 24 Tipo de cliente 2 223 224 N
    # 25 Subclasse de consumo 2 225 226 N
    # 26 Número do terminal telefônico principal 12 227 238 X
    # 27 CNPJ do emitente 14 239 252 N
    # 28 Número ou código da fatura comercial 20 253 272 X
    # 29 Valor total da fatura comercial 12 273 284 N
    # 30 Data de leitura anterior 8 285 292 N
    # 31 Data de leitura atual 8 293 300 N
    # 32 Brancos - reservado para uso futuro 50 301 350 X
    # 33 Brancos - reservado para uso futuro 8 351 358 N
    # 34 Informações adicionais 30 359 388 X
    # 35 Brancos - reservado para uso futuro 5 389 393 X
    # 36 Código de Autenticação Digital do registro 32 394 425 X
  end

  def nf_hash
    cnpj = pessoa.cpf_cnpj.rjust(14, "0")
    nf = '006213487'
    valor = (base_calculo_icms*100).to_i.to_s.rjust(12, "0")
    icms = valor
    icms_valor = '000000000000'
    md5 = Digest::MD5.new
    puts cnpj
    puts nf
    puts valor
    puts icms
    puts icms_valor
    md5.hexdigest(cnpj + nf + valor + icms + icms_valor).upcase.gsub(/(.{4})(?=.)/, '\1.\2')
  end
end
