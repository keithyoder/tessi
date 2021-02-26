class Classificacao < ApplicationRecord
  enum tipo: {
    Instalação: 1,
    Reparo: 2,
    Transferência: 3,
    Retirada: 4,
    Atendimento: 5,
  }
  scope :atendimentos, -> { where(tipo: :Atendimento) }
  scope :os, -> { where.not(tipo: :Atendimento) }
end
