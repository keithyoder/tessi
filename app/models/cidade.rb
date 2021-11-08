# frozen_string_literal: true

require 'csv'

class Cidade < ApplicationRecord
  belongs_to :estado
  has_many :bairros
  has_many :logradouros, through: :bairros
  has_many :pessoas, through: :logradouros
  has_many :conexoes, through: :pessoas
  has_many :pontos, through: :conexoes
  scope :assinantes, lambda {
    select('cidades.*, pontos.tecnologia').joins(:conexoes, :pontos).distinct
  }

  def titulo
    'Cidade'
  end

  def search
    'nome_cont'
  end

  def self.to_csv
    attributes = %w[id nome estado ibge]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |cidade|
        csv << attributes.map{ |attr| cidade.send(attr) }
      end
    end
  end

  def nome_uf
    nome + ' - ' + estado.sigla
  end

  def quantas_conexoes(tipo)
    collection = conexoes.ativo
    case tecnologia
    when 1
      collection = collection.radio
    when 2
      collection = collection.fibra
    end

    case tipo
    when 'Pessoa Física'
      collection = collection.pessoa_fisica
    when 'Pessoa Jurídica'
      collection = collection.pessoa_juridica
    end
    collection.count
  end
end
