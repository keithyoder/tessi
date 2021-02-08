class SuspensaoAutomaticaJob < ApplicationJob
  queue_as :default

  def perform
    Contrato.ativos.each(&:atualizar_conexoes)
  end
end
