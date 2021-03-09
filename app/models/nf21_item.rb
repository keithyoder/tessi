class Nf21Item < ApplicationRecord
  belongs_to :nf21

  scope :competencia, ->(mes) { joins(:nf21).where("date_trunc('month', nf21s.emissao) = ?", DateTime.parse(mes + '-01'))}
end
