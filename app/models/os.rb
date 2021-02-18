class Os < ApplicationRecord
  belongs_to :classificacao, optional: true
  belongs_to :pessoa
  belongs_to :conexao, optional: true
  belongs_to :aberto_por, class_name: 'User'
  belongs_to :responsavel, class_name: 'User'
  belongs_to :tecnico_1, class_name: 'User', optional: true
  belongs_to :tecnico_2, class_name: 'User', optional: true
  enum tipo: { Instalação: 1, Reparo: 2, Transferência: 3, Retirada: 4 }
  scope :abertas, -> { where(fechamento: nil) }
  scope :fechadas, -> { where.not(fechamento: nil) }
  scope :por_responsavel, ->(responsavel) { where(responsavel: responsavel) }
  validates :tipo, :descricao, presence: true
  validates :conexao, presence: true, if: :reparo?

  def reparo?
    tipo == 'Reparo'
  end
end
