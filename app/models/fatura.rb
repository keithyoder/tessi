class Fatura < ApplicationRecord
  belongs_to :contrato
  paginates_per 18
  scope :inadimplentes, -> { where("liquidacao is null and vencimento < ?", 5.days.ago) } 
  scope :suspensos, -> { where("liquidacao is null and vencimento < ?", 15.days.ago) } 
end
