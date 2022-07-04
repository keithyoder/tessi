# frozen_string_literal: true

class WebhookEventoJob < ApplicationJob
  queue_as :default
  
  def perform(evento)
    Rails.logger.info "Processando evento #{evento.id} de tipo #{evento&.webhook&.tipo}"
    case evento&.webhook&.tipo
    when 'gerencianet'
      GerencianetClient.processar_webhook(evento)
    end
  end
end
