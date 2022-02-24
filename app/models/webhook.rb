class Webhook < ApplicationRecord
  has_secure_token
  has_many :webhook_eventos, as: :eventos
  enum tipo: {
    banco_do_brasil: 101
  }
end
