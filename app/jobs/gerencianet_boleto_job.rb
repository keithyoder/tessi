# frozen_string_literal: true

class GerencianetBoletoJob < ApplicationJob
  include Sidekiq::Worker
  
  def perform(fatura)
    GerencianetClient.criar_boleto(fatura)
  end
end
  