class AtendimentoDetalhe < ApplicationRecord
  belongs_to :atendimento
  belongs_to :atendente, class_name: 'User'
end
