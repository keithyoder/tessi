class AtendimentoDetalhe < ApplicationRecord
  belongs_to :atendimento
  belongs_to :atendente, class_name: 'User'

  enum tipo: {
    Presencial: 1,
    Telefone: 2,
    WhatsApp: 3,
    Facebook: 4,
    Email: 5,
  }
end
