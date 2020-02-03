require 'csv'

class Cidade < ApplicationRecord
  belongs_to :estado
  has_many :bairros
  has_many :logradouros, through: :bairros
  has_many :pessoas, through: :logradouros
  has_many :conexoes, through: :pessoas
  scope :assinantes, -> { joins(:conexoes).distinct }

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

  def quantas_conexoes(tipo, tecnologia)
    if tecnologia == :Radio
      self.conexoes.radio.count
    elsif tecnologia == :Fibra
      self.conexoes.fibra.count
    end
  end

end
