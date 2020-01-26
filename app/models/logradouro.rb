require 'csv'

class Logradouro < ApplicationRecord
  belongs_to :bairro
  has_many :pessoas

  def endereco
    self.nome + ' - ' + self.bairro.nome_cidade_uf
  end
end