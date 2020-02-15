class AtualizarRadiusJob < ApplicationJob
  queue_as :default

  def perform
    Conexao.all.each do |conexao|
      conexao.touch
    end
  end
end

#AtualizarRadiusJob.perform_now()
