class FibraCaixa < ApplicationRecord
  belongs_to :fibra_rede
  has_one :ponto, :through => :fibra_rede
end
