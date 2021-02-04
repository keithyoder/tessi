class PingServidoresJob
  #include Sidekiq::Worker

  def perform
    Servidor.ativo.each do |servidor|
      servidor.up = servidor.ping?
      servidor.save
    end
  end
end

#Sidekiq::Cron::Job.create(name: 'Ping Concentradores - cada 5 min', cron: '*/5 * * * *', class: 'PingServidoresJob')
