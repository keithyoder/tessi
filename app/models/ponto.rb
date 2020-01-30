require 'snmp'

class Ponto < ApplicationRecord
  belongs_to :servidor
  has_many :conexoes
  has_many :autenticacoes, :through => :conexoes, :source => :autenticacoes
  
  enum tecnologia: {:Radio => 1, :Fibra => 2}
  enum sistema: {:Ubnt => 1, :Mikrotik => 2, :Chima => 3, :Outro => 4}

  before_save do
    begin
      info = self.snmp
      self.frequencia = info[:frequencia]
      self.ssid = info[:ssid]
    rescue
    end
  end

  def self.to_csv
    attributes = %w{id nome ip sistema tecnologia}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |estado|
        csv << attributes.map{ |attr| estado.send(attr) }
      end
    end
  end

  def snmp
    campos = {
      :uptime => "SNMPv2-MIB::sysUpTime.0",
      :ssid => "SNMPv2-SMI::enterprises.41112.1.4.5.1.2.1",
      :frequencia => "SNMPv2-SMI::enterprises.41112.1.4.1.1.4.1"
    }
    SNMP::Manager.open(:host => self.ip.to_s, :community => 'public', :port => 161, :version => :SNMPv1) do |manager|
      response = manager.get(campos.values)
      result = {}
      response.each_varbind do |vb|
          result.merge!(campos.key(vb.name.to_s) => vb.value)
      end
      result
    end
  end
end
