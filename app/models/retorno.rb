class Retorno < ApplicationRecord
  belongs_to :pagamento_perfil
  has_one_attached :arquivo
end
