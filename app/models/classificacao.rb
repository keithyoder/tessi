class Classificacao < ApplicationRecord
  enum tipo: { Instalação: 1, Reparo: 2, Transferência: 3 }
end
