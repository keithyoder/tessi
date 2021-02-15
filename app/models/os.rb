class Os < ApplicationRecord
  belongs_to :classificacao, optional: true
  belongs_to :pessoa
  belongs_to :conexao, optional: true
  belongs_to :aberto_por, class_name: 'User'
  belongs_to :responsavel, class_name: 'User'
  belongs_to :tecnico_1, class_name: 'User', optional: true
  belongs_to :tecnico_2, class_name: 'User', optional: true
  enum tipo: { Instalação: 1, Reparo: 2, Transferência: 3, Retirada: 4 }
end
