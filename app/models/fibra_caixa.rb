class FibraCaixa < ApplicationRecord
  belongs_to :fibra_rede
  has_one :ponto, :through => :fibra_rede
  has_many :conexoes, :foreign_key => :caixa_id
  
end
