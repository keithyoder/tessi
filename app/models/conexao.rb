class Conexao < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  belongs_to :ponto
  scope :bloqueado, -> { where("bloqueado") }
end
