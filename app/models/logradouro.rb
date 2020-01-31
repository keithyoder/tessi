require 'csv'

class Logradouro < ApplicationRecord
  belongs_to :bairro
  has_many :pessoas
  has_many :conexoes, :through => :pessoas

  def endereco
    self.nome + ' - ' + self.bairro.nome_cidade_uf
  end
end