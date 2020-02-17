class Fatura < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :contrato
  belongs_to :pagamento_perfil
  has_one :pessoa, through: :contrato
  paginates_per 18
  scope :inadimplentes, -> { where("liquidacao is null and vencimento < ?", 5.days.ago) }
  scope :suspensos, -> { where("liquidacao is null and vencimento < ?", 15.days.ago) }
  enum meio_liquidacao: { :RetornoBancario => 1, :Dinheiro => 2, :Cheque => 3, :CartaoCredito => 4, :Outros => 5 }

  def boleto
    Brcobranca::Boleto::Santander.new(
    {
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
    })
  end
end
