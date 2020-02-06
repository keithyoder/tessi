class Contrato < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  has_many :faturas
  has_many :conexoes
  scope :suspendivel, -> {
    joins(:conexoes)
    .joins(:faturas)
    .where("not bloqueado and liquidacao is null and vencimento < ?", 15.days.ago)
    .distinct
  } 
  scope :liberavel, -> {
    joins(:conexoes)
    .joins("LEFT OUTER JOIN faturas ON contratos.id = faturas.contrato_id and liquidacao is null and vencimento < '#{15.days.ago}'")
    .where("bloqueado and cancelamento is null")
    .group("contratos.id")
    .having("count(faturas.*) = 0")
    .distinct
  } 
end