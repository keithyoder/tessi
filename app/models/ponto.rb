require 'snmp'

class Ponto < ApplicationRecord
  belongs_to :servidor
  has_many :conexoes
  has_many :autenticacoes, :through => :conexoes, :source => :autenticacoes
  
  enum tecnologia: {:Radio => 1, :Fibra => 2}
  enum sistema: {:Ubnt => 1, :Mikrotik => 2, :Chima => 3, :Outro => 4}
  enum equipamento: { 'Ubiquiti Loco M5' => 'locoM5', 'Ubiquiti Rocket M5' => 'rocketM5',
    'Ubiquiti Litebeam AC-16-120' => 'litebeamAC' }

  before_save do
    begin
      info = self.snmp
      self.frequencia = info[:frequencia]
      self.ssid = info[:ssid]
      self.canal_tamanho = info[:canal_tamanho]
    rescue
    end
  end

  def to_csv
    attributes = %w{id nome ip sistema tecnologia}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |estado|
        csv << attributes.map{ |attr| estado.send(attr) }
      end
    end
  end

  def frequencia_text
    self.frequencia.to_s + " MHz" + (self.canal_tamanho.present? ? " (" + self.canal_tamanho.to_s + ")" : "")
  end

  def snmp
    campos = {
      :uptime => "SNMPv2-MIB::sysUpTime.0",
      :ssid => "SNMPv2-SMI::enterprises.41112.1.4.5.1.2.1",
      :frequencia => "SNMPv2-SMI::enterprises.41112.1.4.1.1.4.1",
      :canal_tamanho => "SNMPv2-SMI::enterprises.41112.1.4.5.1.14.1",
      :conectados => "SNMPv2-SMI::enterprises.41112.1.4.5.1.15.1",
      :qualidade_airmax => "SNMPv2-SMI::enterprises.41112.1.4.6.1.3.1",
      :station_ccq => "SNMPv2-SMI::enterprises.41112.1.4.5.1.7.1"
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
