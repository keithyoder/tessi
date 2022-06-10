# frozen_string_literal: true

class GerencianetBoletoJob < ApplicationJob
    queue_as :default
  
    def perform(fatura)
      GerencianetClient.criar_boleto(fatura)
    end
  end
  