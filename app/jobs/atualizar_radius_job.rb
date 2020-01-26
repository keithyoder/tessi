class AtualizarRadiusJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Conexao.all.each do | conexao |
        puts conexao.usuario
        conexao.touch
      end
  end
end

AtualizarRadiusJob.perform_now()
