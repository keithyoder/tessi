# frozen_string_literal: true

class Fatura < ApplicationRecord
  require 'digest'
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
  has_one :nf21
  has_one_attached :nf_pdf
  paginates_per 18
  scope :pagas, -> { where.not(liquidacao: nil) }
  scope :em_aberto, -> { where(liquidacao: nil, cancelamento: nil) }
  scope :inadimplentes, -> { where('vencimento < ?', 5.days.ago).em_aberto }
  scope :suspensos, -> { where('vencimento < ?', 15.days.ago).em_aberto }
  scope :registradas, -> { where.not(registro: nil) }
  scope :nao_registradas, -> { where(registro: nil) }
  scope :vencidas, -> { where('vencimento < ?', 1.day.ago).em_aberto }
  scope :a_vencer, -> { where('vencimento > ?', Date.today).em_aberto }
  scope :sem_nota, lambda {
                     left_joins(:nf21).joins(:contrato).where('contratos.emite_nf').group('faturas.id').having('count(nf21s.*) = 0')
                   }
  scope :notas_a_emitir, ->(range) { where(liquidacao: range).where('vencimento > ?', 3.months.ago).sem_nota }

  validate :validar_liquidacao?, if: :liquidacao_changed?

  enum meio_liquidacao: {
    RetornoBancario: 1,
    Dinheiro: 2,
    Cheque: 3,
    CartaoCredito: 4,
    Outros: 5
  }

  after_update do
    contrato.atualizar_conexoes if saved_change_to_liquidacao?
  end

  def remessa
    Brcobranca::Remessa::Pagamento.new remessa_attr
  end

  def boleto # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    info = {
      convenio: pagamento_perfil.cedente,
      cedente: Setting.razao_social,
      documento_cedente: Setting.cnpj,
      sacado: pessoa.nome,
      sacado_documento: pessoa.cpf_cnpj,
      valor: valor,
      agencia: pagamento_perfil.agencia,
      conta_corrente: pagamento_perfil.conta,
      carteira: pagamento_perfil.carteira,
      variacao: 'COB',
      especie_documento: 'DS',
      nosso_numero: nossonumero,
      data_vencimento: vencimento,
      instrucao1: "Desconto de #{number_to_currency(contrato.plano.desconto)} para pagamento até o dia #{I18n.l(vencimento)}",
      instrucao2: "Mensalidade de Internet - SCM - Plano: #{contrato.plano.nome}",
      instrucao3: "Período de referência: #{I18n.l(periodo_inicio)} - #{I18n.l(periodo_fim)}",
      instrucao4: "Após o vencimento cobrar multa de #{Setting.multa.to_f * 100}% e juros de #{Setting.juros.to_f * 100}% ao mês (pro rata die)",
      instrucao5: "S.A.C #{Setting.telefone} - sac.tessi.com.br",
      instrucao6: 'Central de Atendimento da Anatel 1331 ou 1332 para Deficientes Auditivos.',
      sacado_endereco: "#{pessoa.endereco} - #{pessoa.bairro.nome_cidade_uf}",
      cedente_endereco: 'Rua Treze de Maio, 5B - Centro - Pesqueira - PE 55200-000'
    }
    case pagamento_perfil.banco
    when 33
      Brcobranca::Boleto::Santander.new(info)
    when 1
      Brcobranca::Boleto::BancoBrasil.new(info)
    when 104
      Brcobranca::Boleto::Caixa.new(info)
    end
  end

  def pix
    @pix ||= QrcodePixRuby::Payload.new(
      url: 'https://example.com',
      merchant_name: Setting.razao_social,
      merchant_city: 'PESQUEIRA',
      amount: valor,
      transaction_id: id,
      repeatable: false
    )
  end

  def base_calculo_icms
    (valor_liquidacao.presence || valor) - juros_recebidos.to_f
  end

  def aliquota
    0
  end

  def valor_icms
    base_calculo_icms * aliquota
  end

  def cfop
    cfop = if pessoa.cidade.estado.sigla == 'PE'
             5300
           else
             6300
           end
    if pessoa.ie.present?
      cfop + 3
    else
      cfop + 7
    end
  end

  def gerar_nota
    return unless nf21.blank?

    next_nf = (Nf21.maximum(:numero).presence || 0) + 1
    emissao = liquidacao.presence || vencimento
    nf = Nf21.create(fatura_id: id, emissao: emissao, numero: next_nf)
    nf.gerar_registros
  end

  def baixar?
    return false unless liquidacao.present? || cancelamento.present?

    retorno.blank? && baixa.blank?
  end

  def estornar?
    liquidacao.present? && retorno.blank? && nf21.blank?
  end

  def cancelar?
    liquidacao.blank?
  end

  def gerar_nota?
    return false unless nf21.blank?
    return mes_referencia(liquidacao) == mes_referencia(Date.today) if liquidacao.present?

    mes_referencia(vencimento) == mes_referencia(Date.today)
  end

  def nosso_numero_remessa
    nossonumero + (dv_santander.to_s if pagamento_perfil.banco == 33).to_s
  end

  private

  def remessa_attr # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    {
      valor: valor,
      data_vencimento: vencimento,
      numero: nossonumero,
      nosso_numero: nosso_numero_remessa,
      documento_sacado: pessoa.cpf_cnpj,
      nome_sacado: pessoa.nome,
      endereco_sacado: pessoa.endereco,
      bairro_sacado: bairro.nome,
      cep_sacado: logradouro.cep,
      cidade_sacado: cidade.nome,
      uf_sacado: estado.sigla,
      valor_desconto: plano.desconto,
      data_desconto: plano.desconto.positive? ? vencimento : nil,
      codigo_multa: '4',
      percentual_multa: Setting.multa.to_f * 100,
      valor_mora: (Setting.juros.to_f * valor / 30).round(2)
    }.merge ocorrencia_attr
  end

  def ocorrencia_attr # rubocop:disable Metrics/MethodLength
    if baixar?
      {
        cod_primeira_instrucao: pagamento_perfil.banco == 1 ? '44' : '00',
        identificacao_ocorrencia: '02'
      }
    else
      {
        cod_primeira_instrucao: pagamento_perfil.banco == 1 ? '22' : '00',
        identificacao_ocorrencia: '01'
      }
    end
  end

  def dv_santander
    nossonumero.modulo11(
      multiplicador: (2..9).to_a,
      mapeamento: { 10 => 0, 11 => 0 }
    ) { |total| 11 - (total % 11) }
  end

  def validar_liquidacao?
    return if liquidacao.blank? || (1.week.ago..Date.today).cover?(liquidacao)
    return unless meio_liquidacao == 'Dinheiro'

    errors.add(:liquidacao, 'fora da faixa permitida')
  end

  def mes_referencia(date)
    date.strftime('%Y-%m')
  end
end
