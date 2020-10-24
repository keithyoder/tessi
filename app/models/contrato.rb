class Contrato < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  belongs_to :pagamento_perfil
  has_many :faturas
  has_many :conexoes
  has_many :execoes
  scope :ativos, lambda {
    where.not(cancelamento: nil)
  }
  scope :suspendivel, lambda {
          joins(:conexoes)
            .joins(:faturas)
            .where(bloqueado: false)
            .where(liquidacao: nil)
            .where('vencimento < ?', 15.days.ago)
            .distinct
        }
  scope :liberavel, lambda {
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
end
