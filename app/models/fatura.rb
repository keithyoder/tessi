class Fatura < ApplicationRecord
  belongs_to :contrato
  paginates_per 18
  scope :inadimplente, -> { where("liquidacao is null and vencimento < ?", 5.days.ago) } 
  scope :suspenso, -> { where("liquidacao is null and vencimento < ?", 15.days.ago) } 
end
