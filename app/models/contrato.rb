class Contrato < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  belongs_to :pagamento_perfil
  has_many :faturas
  has_many :conexoes
  has_many :excecoes
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

  def faturas_em_atraso(dias)
    faturas.where('liquidacao is null and vencimento < ?', dias.days.ago).count
  end

  def contrato_e_nome
    "#{id} - #{pessoa.nome}"
  end

  def suspender?
    # suspender se tiver faturas em atraso mas não tem regra de exeção para
    # liberar ou se tiver uma regra para bloquear.
    (faturas_em_atraso(15).positive? && excecoes.validas_para_desbloqueio.none?) || excecoes.validas_para_bloqueio.any?
  end

  def atualizar_conexoes
    conexoes.each do |conexao|
      conexao.update!(
        inadimplente: faturas_em_atraso(5).positive?
      )
      next unless auto_bloqueio?

      conexao.update!(
        bloqueado: suspender?
      )
    end
end
