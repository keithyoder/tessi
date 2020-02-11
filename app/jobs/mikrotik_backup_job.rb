class MikrotikBackupJob < ApplicationJob
  queue_as :default

  def perform
    Servidor.ativo.each do | servidor |
      begin
        servidor.copiar_backup
      rescue
      end
    end
  end
end

#MikrotikBackupJob.perform_later()
Sidekiq::Cron::Job.create(name: 'Backup Concentradores - uma vez por dia', cron: '20 9 * * *', class: 'MikrotikBackupJob')
