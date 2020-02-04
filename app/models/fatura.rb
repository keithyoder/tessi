class Fatura < ApplicationRecord
  belongs_to :contrato
  paginates_per 18
end
