require 'csv'

class Servidor < ApplicationRecord
  has_many :pontos
  has_many :conexoes, through: :pontos
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
    if self.usuario.presence? && self.senha.presence?
      begin
        MTik::command(:host => self.ip.to_s, :user => self.usuario,
          :pass => self.senha, :use_ssl => :true, :command => command)
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
end
