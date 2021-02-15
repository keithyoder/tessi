class Classificacao < ApplicationRecord
  enum tipo: { Instalação: 1, Reparo: 2, Transferência: 3, Retirada: 4 }
end
