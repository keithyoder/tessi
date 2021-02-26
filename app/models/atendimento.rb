class Atendimento < ApplicationRecord
  belongs_to :pessoa
  belongs_to :classificacao
  belongs_to :responsavel, class_name: 'User'
  belongs_to :contrato, optional: true
  belongs_to :conexao, optional: true
  belongs_to :fatura, optional: true
  has_many :detalhes, class_name: 'AtendimentoDetalhe'
end
