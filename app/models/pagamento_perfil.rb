class PagamentoPerfil < ApplicationRecord
  enum tipo: { "Boleto" => 3, "Débito Automático" => 2 }
end
