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
      documento_sacado: pessoa.cpf.gsub(/[^0-9 ]/, ''),
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
      :cedente => "Tessi - Serviços em Telecomunicações Ltda",
      :documento_cedente => '07.159.053/0001-07',
      :sacado => pessoa.nome,
      :sacado_documento => pessoa.cpf,
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
      :instrucao4 => "Após o vencimento cobrar multa de 2% e juros de 1% ao mês (pro rata die)",
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
end
