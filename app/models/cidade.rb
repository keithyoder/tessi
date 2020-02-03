require 'csv'

class Cidade < ApplicationRecord
  belongs_to :estado
  has_many :bairros
  has_many :logradouros, through: :bairros
  has_many :pessoas, through: :logradouros
  has_many :conexoes, through: :pessoas
  has_many :pontos, through: :conexoes
  scope :assinantes, -> { select('cidades.*, pontos.tecnologia').joins(:conexoes, :pontos).distinct }

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

  def quantas_conexoes(tipo, velocidade)
    collection = self.conexoes
    case tipo
    when "Pessoa Física"
      collection = collection.pessoa_fisica
    when "Pessoa Jurídica"
      collection = collection.pessoa_juridica
    end
    case velocidade
    when 1
      collection = collection.ate_1M
    when 2
      collection = collection.ate_2M
    when 8
      collection = collection.ate_8M
    when 12
      collection = collection.ate_12M
    when 34
      collection = collection.ate_34M
    when 100
      collection = collection.acima_34M
    end
    collection.count
  end

end
