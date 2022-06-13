# frozen_string_literal: true

class GerencianetBoletoJob < ApplicationJob
  
  def perform(fatura)
    GerencianetClient.criar_boleto(fatura)
  end
end
  