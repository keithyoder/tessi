class Servidor < ApplicationRecord
  require 'csv'
  require 'open-uri'
  has_many :pontos
  has_many :conexoes, through: :pontos
  has_many :autenticacoes, :through => :pontos
  has_one_attached :backup

  scope :ativo, -> { where("ativo") }

  def self.to_csv
    attributes = %w{id nome ip ativo api_porta ssh_porta snmp_porta snmp_comunidade}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |servidor|
        csv << attributes.map{ |attr| servidor.send(attr) }
      end
    end
  end

  def mk_command(command)
    if self.usuario.present? && self.senha.present?
      begin
        MTik::command(:host => self.ip.to_s, :user => self.usuario,
          :pass => self.senha, :use_ssl => :true, :unencrypted_plaintext => :true, :command => command)
      rescue
      end
    end
  end

  def ppp_users
    begin
      users = self.mk_command('/ppp/active/print')
      (users[0].count - 1).to_s
    rescue StandardError => e  
      e.message
    end
  end

  def hotspot_users
    begin
      users = self.mk_command('/ip/hotspot/active/print')
      (users[0].count - 1).to_s
    rescue StandardError => e  
      e.message
    end
  end

  def system_info
    begin
      result = self.mk_command('/system/resource/print')[0][0]
      result.slice("uptime", "version", "cpu-load", "board-name")
    rescue StandardError => e  
      e.message
    end
  end

  def ping?
    check = Net::Ping::External.new(self.ip.to_s)
    check.ping?
  end

  def autenticando?
    self.autenticacoes.where('authdate > ?', 12.hours.ago).count > 0
  end

  def copiar_backup
    login = URI.escape(self.usuario) + ':' + URI.escape(self.senha)
    filename = URI.escape(self.nome)
    fi = open("ftp://#{login}@#{self.ip.to_s}/#{filename}-backup.rsc")
    self.backup.attach(io: fi, filename: "#{self.nome}-backup.rsc")
  end

  def backup_status
    if self.backup.attached?
      if self.backup.created_at > 1.week.ago
        "Recente"
      else
        "Antigo"
      end
    else
      "Nenhum"
    end
  end
end
