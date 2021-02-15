class Contrato < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  belongs_to :pagamento_perfil
  has_many :faturas, dependent: :delete_all
  has_many :conexoes
  has_many :excecoes, dependent: :delete_all
  scope :ativos, lambda {
    where(cancelamento: nil)
  }
  scope :suspendiveis, lambda {
          joins(:conexoes)
            .joins(:faturas)
            .where(bloqueado: false)
            .where(liquidacao: nil)
            .where('vencimento < ?', 15.days.ago)
            .distinct
        }
  scope :liberaveis, lambda {
          joins(:conexoes)
            .joins("LEFT OUTER JOIN faturas ON contratos.id = faturas.contrato_id and liquidacao is null and vencimento < '#{15.days.ago}'")
            .where('bloqueado and cancelamento is null')
            .group('contratos.id')
            .having('count(faturas.*) = 0')
            .distinct
        }

  after_create :gerar_faturas

  before_destroy :verificar_exclusao, prepend: true

  def faturas_em_atraso(dias)
    faturas.where('liquidacao is null and vencimento < ?', dias.days.ago).count
  end

  def contrato_e_nome
    "#{id} - #{pessoa.nome}"
  end

  def gerar_faturas
    nossonumero = Fatura.select('MAX(nossonumero::int) as nossonumero')
                        .where(pagamento_perfil_id: pagamento_perfil_id)
                        .to_a[0][:nossonumero].to_i
    vencimento = faturas.maximum(:vencimento) || primeiro_vencimento - 1.month
    inicio = faturas.maximum(:vencimento) || adesao
    parcela = faturas.maximum(:parcela) || 0
    (1..prazo_meses).each do
      nossonumero += 1
      vencimento += 1.month
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
    puts atraso
    conexoes.each do |conexao|
      conexao.update!(
        inadimplente: atraso
      )
      next unless conexao.auto_bloqueio?

      conexao.update!(
        bloqueado: suspenso
      )
    end
  end

  private

  def verificar_exclusao
    return if faturas.registradas.none? && faturas.pagas.none?

    errors[:base] << 'Não pode excluir um contrato que tem faturas pagas ou boletos registrados'
    throw :abort
  end

  def fracao_de_mes(inicio, fim)
    (fim - inicio).to_f / (fim - (fim - 1.month)).to_f
  end
end
