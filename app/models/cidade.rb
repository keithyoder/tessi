require 'csv'

class Cidade < ApplicationRecord
  belongs_to :estado
  has_many :bairros

  def titulo
    "Cidade"
  end

  def search
    "nome_cont"
  end

  def self.to_csv
    attributes = %w{id nome estado ibge}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |cidade|
        csv << attributes.map{ |attr| cidade.send(attr) }
      end
    end
  end

  def nome_uf
    self.nome + " - " + self.estado.sigla
  end
end
