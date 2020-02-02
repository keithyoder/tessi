class Contrato < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  has_many :faturas
end
