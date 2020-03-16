class FibraRede < ApplicationRecord
  belongs_to :ponto
  has_many :fibra_caixas
end
