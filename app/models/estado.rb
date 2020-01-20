require 'csv'

class Estado < ApplicationRecord
  has_many :cidades

  def self.to_csv
    attributes = %w{id sigla nome ibge}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |estado|
        csv << attributes.map{ |attr| estado.send(attr) }
      end
    end
  end
end
