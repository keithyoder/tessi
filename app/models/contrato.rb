class Contrato < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  belongs_to :pagamento_perfil
  has_many :faturas, dependent: :delete_all
  has_many :conexoes
  has_many :excecoes, dependent: :delete_all

  # contratos que tem menos conexoes que permitido.
  scope :disponiveis, lambda {
    where(id: Contrato.select('contratos.id')
      .left_joins(:conexoes)
      .group('contratos.id')
      .having('count(conexoes.*) < contratos.numero_conexoes'))
  }

  scope :ativos, lambda {
    where(cancelamento: nil)
  }
  scope :suspendiveis, lambda {
          includes(:pessoa)
            .joins(:conexoes, :faturas)
            .where(
              conexoes: { bloqueado: false },
              faturas: { liquidacao: nil, cancelamento: nil }
            )
            .where('faturas.vencimento < ?', 15.days.ago)
            .distinct
        }
  scope :liberaveis, lambda {
          joins(:conexoes)
            .joins("LEFT OUTER JOIN faturas ON contratos.id = faturas.contrato_id and faturas.cancelamento is null and liquidacao is null and vencimento < '#{15.days.ago}'")
            .where(
              cancelamento: nil,
              conexoes: { bloqueado: true }
            )
            .group('contratos.id')
            .having('count(faturas.*) = 0')
            .distinct
        }
  scope :cancelaveis, lambda {
    joins(:pessoa, :faturas, :plano)
      .where(faturas: { liquidacao: nil, cancelamento: nil })
      .where('faturas.vencimento < ?', 1.day.ago)
      .group('contratos.id, pessoas.id, planos.id')
      .having('COUNT(faturas.*) > 4').ativos
  }
  scope :renovaveis, lambda {
    joins(:pessoa, :plano)
      .joins("LEFT JOIN faturas ON contratos.id = faturas.contrato_id AND faturas.periodo_fim > '#{30.days.from_now}'")
      .group('contratos.id', 'pessoas.id', 'planos.id')
      .having('COUNT(faturas.*) = 0').ativos
  }
  scope :fisica, -> { joins(:pessoa).where('pessoas.tipo = 1') }
  scope :juridica, -> { joins(:pessoa).where('pessoas.tipo = 2') }
  scope :novos_por_mes, ->(mes) { where("date_trunc('month', adesao) = ?", mes) }

  scope :sem_conexao, lambda {
    joins(:pessoa, :plano)
      .left_outer_joins(:conexoes)
      .group('contratos.id', 'pessoas.id', 'planos.id')
      .having('COUNT(conexoes.*) = 0').ativos
  }

  after_create :gerar_faturas

  after_save :after_save

  before_destroy :verificar_exclusao, prepend: true

  def faturas_em_atraso(dias)
    faturas.where(liquidacao: nil, cancelamento: nil)
           .where('vencimento < ?', dias.days.ago).count
  end

  def contrato_e_nome
    "#{id} - #{pessoa.nome}"
  end

  def gerar_faturas(quantas = prazo_meses)
    nossonumero = pagamento_perfil.proximo_nosso_numero
    vencimento = faturas.maximum(:vencimento) || primeiro_vencimento - 1.month
    inicio = faturas.maximum(:vencimento) || adesao
    parcela = faturas.maximum(:parcela) || 0
    (1..quantas).each do
      nossonumero += 1
      vencimento = proximo_mes(vencimento)
      parcela += 1
      instalacao = if parcela <= parcelas_instalacao
                     (valor_instalacao / parcelas_instalacao).round(2)
                   else
                     0
                   end
      valor = (plano.mensalidade * fracao_de_mes(inicio, vencimento)).round(2) + instalacao
      faturas.create!(
        pagamento_perfil_id: pagamento_perfil_id,
        valor: valor,
        valor_original: valor,
        parcela: parcela,
        vencimento: vencimento,
        vencimento_original: vencimento,
        nossonumero: nossonumero,
        periodo_inicio: inicio + 1.day,
        periodo_fim: vencimento
      )
      inicio = vencimento
    end
  end

  def suspender?
    # suspender se tiver faturas em atraso mas não tem regra de exeção para
    # liberar ou se tiver uma regra para bloquear.
    (faturas_em_atraso(15).positive? && excecoes.validas_para_desbloqueio.none?) || excecoes.validas_para_bloqueio.any?
  end

  def atualizar_conexoes
    suspenso = suspender?
    atraso = faturas_em_atraso(5).positive?
    conexoes.each do |conexao|
      next unless conexao.auto_bloqueio?

      conexao.update!(
        bloqueado: suspenso,
        inadimplente: atraso
      )
    end
  end

  def renovar
    faturas_a_vencer = faturas.a_vencer.count
    # se faltar uma fatura, gera mais 12.  Se faltar mais, gera a quantidade para completar 12.
    faturas_a_vencer = 0 if faturas_a_vencer <= 1
    gerar_faturas(prazo_meses - faturas_a_vencer)
  end

  def self.to_csv
    headers = %i[ID Assinante Plano Adesão Cancelamento]
    CSV.generate(headers: true) do |csv|
      csv << headers

      all.each do |contrato|
        csv << [
          contrato.id,
          contrato.pessoa.nome,
          contrato.plano.nome,
          contrato.adesao,
          contrato.cancelamento
        ]
      end
    end
  end

  private

  def verificar_exclusao
    return if faturas.registradas.none? && faturas.pagas.none?

    errors[:base] << 'Não pode excluir um contrato que tem faturas pagas ou boletos registrados'
    throw :abort
  end

  def after_save
    verificar_cancelamento if saved_change_to_cancelamento?
    alterar_forma_pagamento if saved_change_to_pagamento_perfil_id?
  end

  def verificar_cancelamento
    # apagar todas as faturas que nao foram pagas ou registradas
    # e que sao referentes a periodos após o cancelamento
    faturas.where(liquidacao: nil, registro: nil)
           .where('periodo_inicio >= ?', cancelamento)
           .each(&:destroy)
    parcial = faturas.where(liquidacao: nil, registro: nil)
           .where('? between periodo_inicio and periodo_fim', cancelamento)
    parcial.each { |fatura| fatura.update!(valor: fatura.valor * fracao_de_mes(fatura.periodo_inicio, cancelamento))}
  end

  def alterar_forma_pagamento
    faturas.a_vencer.nao_registradas.each(&:destroy)
    renovar
  end

  def fracao_de_mes(inicio, fim)
    if fim.end_of_month == fim
      dias_no_mes = [fim - inicio, 31].min
    else
      dias_no_mes = fim - (fim - 1.month)
    end
    (fim - inicio).to_f / dias_no_mes.to_f
  end

  def proximo_mes(data)
    data += 1.month
    data.change(day: [dia_vencimento, data.end_of_month.day].min)
  end
end
