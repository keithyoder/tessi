# frozen_string_literal: true

class WebhookEventoJob < ApplicationJob
    queue_as :default
  
    def perform(evento)
      case evento.tipo
      when :gerencianet
        
      end
    end
  end
  