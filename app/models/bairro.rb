class Bairro < ApplicationRecord
  belongs_to :cidade
  has_many :logradouros
  geocoded_by :nome_cidade_uf
  after_validation :geocode

  def nome_cidade_uf
    self.nome + " - " + self.cidade.nome_uf
  end

end
