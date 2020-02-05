class Fatura < ApplicationRecord
  belongs_to :contrato
  paginates_per 18
  scope :inadimplentes, -> { where("liquidacao is null and vencimento < ?", 5.days.ago) } 
  scope :suspensos, -> { where("liquidacao is null and vencimento < ?", 15.days.ago) } 
  enum meio_liquidacao: {:RetornoBancario => 1, :Dinheiro => 2, :Cheque => 3, :CartaoCredito => 4, :Outros => 5}
end
