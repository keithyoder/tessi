class PingServidoresJob
  include Sidekiq::Worker
  
  def perform(name, count)
    Servidor.ativo.each do | servidor |
      servidor.up = servidor.ping?
      servidor.save
    end
  end
end
