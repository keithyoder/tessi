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
    collection = self.conexoes.ativo
    case tecnologia
    when :Radio
      collection = collection.radio
    when :Fibra
      collection = collection.fibra
    end
    case tipo
    when "Pessoa Física"
      colleciton = collection.pessoa_fisica
    when "Pessoa Jurídica"
      collection = collection.pessoa_juridica
    end
    collection.count
  end

end
