class MikrotikBackupJob < ApplicationJob
  #include Sidekiq::Worker

  def perform
    Servidor.ativo do |servidor|
      begin
        servidor.copiar_backup
      rescue Errno::ETIMEDOUT => exception
        Rails.logger.info exception.message
        next
      end
    end
  end
end

#MikrotikBackupJob.perform_later()
#Sidekiq::Cron::Job.create(name: 'Backup Concentradores - uma vez por dia', cron: '20 9 * * *', class: 'MikrotikBackupJob')
