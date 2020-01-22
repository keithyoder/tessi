class Pessoa < ApplicationRecord
  belongs_to :logradouro

  enum tipo: {"Pessoa Física" => 1, "Pessoa Júridica" => 2}

  def endereco
    self.logradouro.nome + ', ' + self.numero + ' ' + self.complemento
  end
end
