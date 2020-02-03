class MikrotikBackupJob < ApplicationJob
  queue_as :default

  def perform
    Servidor.find(1).copiar_backup
  end
end

#MikrotikBackupJob.perform_later()
