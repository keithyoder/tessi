require 'csv'

class Bairro < ApplicationRecord
  belongs_to :cidade
  has_many :logradouros
  has_many :assinantes, -> { assinantes }, source: :pessoas, through: :logradouros

  geocoded_by :nome_cidade_uf
  after_validation :geocode

  def nome_cidade_uf
    self.nome + " - " + self.cidade.nome_uf
  end

end
