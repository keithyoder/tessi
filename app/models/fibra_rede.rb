class FibraRede < ApplicationRecord
  belongs_to :ponto
  has_many :fibra_caixas
  has_many :conexoes, through: :fibra_caixas
end
