class Bairro < ApplicationRecord
  belongs_to :cidade
  has_many :logradouros

  def nome_cidade_uf
    self.nome + " - " + self.cidade.nome_uf
  end

end
