require 'csv'

class Plano < ApplicationRecord
  def self.to_csv
    attributes = %w{id nome mensalidade download upload burst}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |plano|
        csv << attributes.map{ |attr| plano.send(attr) }
      end
    end
  end

  def velocidade
    self.download.to_s + 'M ▼ / ' + self.upload.to_s + 'M ▲'
  end

  def burst_as_string
    if self.burst?
      "Ativiado"
    else
      "Desativado"
    end
  end
end
