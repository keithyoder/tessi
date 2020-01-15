class Cidade < ApplicationRecord
  belongs_to :estado
  has_many :bairros

  def nome_uf
    self.nome + " - " + self.estado.sigla
  end
end
