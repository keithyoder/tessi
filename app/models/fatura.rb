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
  has_many :nf21
  has_one_attached :nf_pdf
  paginates_per 18
  scope :pagas, -> { where.not(liquidacao: nil) }
  scope :em_aberto, -> { where(liquidacao: nil) }
  scope :inadimplentes, -> { where('vencimento < ?', 5.days.ago).em_aberto }
  scope :suspensos, -> { where('vencimento < ?', 15.days.ago).em_aberto }
  scope :registradas, -> { where.not(registro: nil) }
  scope :vencidas, -> { where('vencimento < ?', 1.day.ago).em_aberto }
  scope :a_vencer, -> { where('vencimento > ?', Date.today).em_aberto }

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

  def remessa # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if liquidacao.present? && retorno.blank? && baixa.blank?
      ocorrencia = '02'
      if pagamento_perfil.banco == 1
        cod_primeira_instrucao = '44'
      end
    else
      ocorrencia = '01'
      if pagamento_perfil.banco == 1
        cod_primeira_instrucao = '22'
      end
    end
    Brcobranca::Remessa::Pagamento.new(
      valor: valor,
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
      data_desconto: plano.desconto.positive? ? vencimento : nil,
      cod_primeira_instrucao: cod_primeira_instrucao,
      identificacao_ocorrencia: ocorrencia,
      codigo_multa: '4',
      percentual_multa: Setting.multa * 100,
    )
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
      instrucao4: "Após o vencimento cobrar multa de #{Setting.multa.to_f*100}% e juros de #{Setting.juros.to_f*100}% ao mês (pro rata die)",
      instrucao5: "S.A.C #{Setting.telefone} - sac.tessi.com.br",
      instrucao6: 'Central de Atendimento da Anatel 1331 ou 1332 para Deficientes Auditivos.',
      sacado_endereco: pessoa.endereco + ' - ' + pessoa.bairro.nome_cidade_uf,
      cedente_endereco: 'Rua Treze de Maio, 5B - Centro - Pesqueira - PE 55200-000'
    }
    case pagamento_perfil.banco
    when 33
      Brcobranca::Boleto::Santander.new(info)
    when 1
      Brcobranca::Boleto::BancoBrasil.new(info)
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

  def nf_hash
    cnpj = pessoa.cpf_cnpj.rjust(14, '0')
    nf = nf21.first.numero.to_s.rjust(9, '0')
    valor = (base_calculo_icms * 100).to_i.to_s.rjust(12, '0')
    icms = valor
    icms_valor = '000000000000'
    md5 = Digest::MD5.new
    md5.hexdigest(cnpj + nf + valor + icms + icms_valor).upcase.gsub(/(.{4})(?=.)/, '\1.\2')
  end

  def gerar_nota
    return unless nf21.count.zero?

    next_nf = (Nf21.maximum(:numero).presence || 0) + 1
    nf = Nf21.create(fatura_id: id, emissao: liquidacao, numero: next_nf)
    nf.gerar_registros
  end
end
