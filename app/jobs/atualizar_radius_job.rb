class AtualizarRadiusJob < ApplicationJob
  queue_as :default

  def perform
    Conexao.all.each(&:touch)
  end
end

#AtualizarRadiusJob.perform_now()
