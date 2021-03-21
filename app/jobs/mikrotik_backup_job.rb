class MikrotikBackupJob < ApplicationJob
  # include Sidekiq::Worker

  def perform
    Servidor.ativo.each do |servidor|
      servidor.copiar_backup
    rescue NoMethodError, Errno::ETIMEDOUT, Errno::ECONNREFUSED, Net::FTPPermError, Errno::EHOSTUNREACH => exception
      Rails.logger.info exception.message
      next
    end
  end
end

#MikrotikBackupJob.perform_later()
#Sidekiq::Cron::Job.create(name: 'Backup Concentradores - uma vez por dia', cron: '20 9 * * *', class: 'MikrotikBackupJob')
