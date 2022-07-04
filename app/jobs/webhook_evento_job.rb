# frozen_string_literal: true

class WebhookEventoJob < ApplicationJob
  queue_as :default
  
  def perform(evento)
    case evento&.webhook&.tipo
    when :gerencianet
      GerencianetClient.processar_webhook(evento)
    end
  end
end
