# frozen_string_literal: true

class Fatura < ApplicationRecord
  require 'digest'
  require 'barby'
  require 'barby/barcode/code_25_interleaved'
  require 'barby/barcode/qr_code'
  require 'barby/outputter/svg_outputter'
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

  after_create do
    criar_cobranca if pagamento_perfil.tipo == "API"
  end

  def remessa
    Brcobranca::Remessa::Pagamento.new remessa_attr
  end

  def boleto
    case pagamento_perfil.banco
    when 33
      Brcobranca::Boleto::Santander.new(boleto_attrs)
    when 1
      Brcobranca::Boleto::BancoBrasil.new(boleto_attrs)
    when 104
      Brcobranca::Boleto::Caixa.new(boleto_attrs)
    end
  end

  def pix_base64
    return unless pix.present?

    ::RQRCode::QRCode.new(pix, level: :q).as_png(margin: 0).to_data_url
  end

  def pix_imagem
    return unless pix.present?

    barcode = Barby::QrCode.new(pix, level: :q)
    StringIO.new(
      Barby::SvgOutputter.new(barcode).to_svg(margin: 0)
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

  def boleto_attrs
    {
      convenio: pagamento_perfil.cedente,
      cedente: Setting.razao_social,
      documento_cedente: Setting.cnpj,
      sacado: pessoa.nome.strip,
      sacado_documento: pessoa.cpf_cnpj,
      valor: valor,
      agencia: pagamento_perfil.agencia.to_s.rjust(4, '0'),
      conta_corrente: pagamento_perfil.conta.to_s.rjust(8, '0'),
      carteira: pagamento_perfil.carteira,
      variacao: 'COB',
      especie_documento: 'DS',
      nosso_numero: nossonumero.to_s.rjust(10, '0'),
      data_vencimento: vencimento,
      instrucao1: "Desconto de #{number_to_currency(contrato.plano.desconto)} para pagamento até o dia #{I18n.l(vencimento)}",
      instrucao2: "Mensalidade de Internet - SCM - Plano: #{contrato.plano.nome}",
      instrucao3: "Período de referência: #{I18n.l(periodo_inicio)} - #{I18n.l(periodo_fim)}",
      instrucao4: "S.A.C #{Setting.telefone} - sac.tessi.com.br",
      instrucao5: 'Central de Atendimento da Anatel 1331 ou 1332 para Deficientes Auditivos.',
      instrucao6: "Após o vencimento cobrar multa de #{Setting.multa.to_f * 100}% e juros de #{Setting.juros.to_f * 100}% ao mês (pro rata die)",
      sacado_endereco: "#{pessoa.endereco} - #{pessoa.bairro.nome_cidade_uf}",
      cedente_endereco: 'Rua Treze de Maio, 5B - Centro - Pesqueira - PE 55200-000'
    }
  end

  def codigo_de_barras
    @codigo_de_barras ||= begin
      fator_vencimento = if pagamento_perfil.banco == 364
                           '0000'
                         else
                           (vencimento.to_date - '1997-10-07'.to_date).to_i.to_s
                         end           
      codigo = pagamento_perfil.banco.to_s.rjust(3, '0') + '9' +
               fator_vencimento +
               (valor * 100).to_i.to_s.rjust(10, '0') +
               campo_livre
      dv = codigo.modulo11
      dv = 1 if [0,1,10].any?(dv)
      codigo[0, 4] + dv.to_s + codigo[4...]
    end
  end
  
  def codigo_de_barras_imagem
    barcode = Barby::Code25Interleaved.new(codigo_de_barras)
    StringIO.new(
      Barby::SvgOutputter.new(barcode).to_svg(height: 53, width: 103, margin: 0)
    )
  end

  def linha_digitavel
    bloco1 = "#{codigo_de_barras[0, 4]}#{codigo_de_barras[19, 5]}"
    bloco2 = codigo_de_barras[24, 10]
    bloco3 = codigo_de_barras[34, 10]
    bloco4 = codigo_de_barras[4, 1]
    bloco5 = codigo_de_barras[5, 14]
    "#{bloco1[0, 5]}.#{bloco1[5,4]}#{bloco1.modulo10} #{bloco2[0, 5]}.#{bloco2[5,5]}#{bloco2.modulo10} #{bloco3[0, 5]}.#{bloco3[5,5]}#{bloco3.modulo10} #{bloco4} #{bloco5}"
  end

  def campo_livre
    @campo_livre ||=
      case pagamento_perfil.banco
      when 364
        conta_nosso_numero = (pagamento_perfil.conta/10).to_s.rjust(9, '0') + nossonumero.rjust(11, '0')
        dv = conta_nosso_numero.modulo11
        dv = 1 if dv == 10 || dv == 0
        dv.to_s.rjust(5, '0') + conta_nosso_numero
      when 1
        (pagamento_perfil.cedente).to_s.rjust(13, '0') + nossonumero.rjust(10, '0') + pagamento_perfil.carteira.to_s.rjust(2, '0')
      when 33
        '9'+(pagamento_perfil.cedente).to_s.rjust(7, '0') + nossonumero.rjust(12, '0') + dv_santander.to_s + pagamento_perfil.carteira.to_s.rjust(4, '0')
      end
  end

  private

  def criar_cobranca
    if pagamento_perfil.banco == 364
      GerencianetBoletoJob.perform_async(self)
    end
  end

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
