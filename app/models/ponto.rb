require 'snmp'

class Ponto < ApplicationRecord
  belongs_to :servidor
  has_many :conexoes
  has_many :ip_redes
  has_many :redes, class_name: 'FibraRede'
  has_many :caixas, through: :redes, source: :fibra_caixas
  has_many :autenticacoes, through: :conexoes, source: :autenticacoes
  scope :ativo, -> { joins(:servidor).where('servidores.ativo') }
  scope :fibra, -> { where(tecnologia: :Fibra) }

  enum tecnologia: {
    Radio: 1,
    Fibra: 2
  }
  enum sistema: {
    Ubnt: 1,
    Mikrotik: 2,
    Chima: 3,
    Outro: 4
  }
  enum equipamento: {
    'Ubiquiti Loco M5' => 'locoM5',
    'Ubiquiti Rocket M5' => 'rocketM5',
    'Ubiquiti Litebeam AC-16-120' => 'litebeamAC',
    'Ubiquiti Powerbeam M5' => 'powerbeamM5',
    'Ubiquiti Nanostation M5' => 'nanostationM5'
  }

  after_touch :save
  before_save do
    begin
      info = snmp
      self.frequencia = info[:frequencia]
      self.ssid = info[:ssid]
      self.canal_tamanho = info[:canal_tamanho]
    rescue
    end
  end

  def to_csv
    attributes = %i[id nome ip sistema tecnologia]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |estado|
        csv << attributes.map { |attr| estado.send(attr) }
      end
    end
  end

  def frequencia_text
    frequencia.to_s + ' MHz' + (canal_tamanho.present? ? ' (' + canal_tamanho.to_s + ')' : '')
  end

  def snmp
    campos = {
      uptime: 'SNMPv2-MIB::sysUpTime.0',
      ssid: 'SNMPv2-SMI::enterprises.41112.1.4.5.1.2.1',
      frequencia: 'SNMPv2-SMI::enterprises.41112.1.4.1.1.4.1',
      canal_tamanho: 'SNMPv2-SMI::enterprises.41112.1.4.5.1.14.1',
      conectados: 'SNMPv2-SMI::enterprises.41112.1.4.5.1.15.1',
      qualidade_airmax: 'SNMPv2-SMI::enterprises.41112.1.4.6.1.3.1',
      station_ccq: 'SNMPv2-SMI::enterprises.41112.1.4.5.1.7.1'
    }
    snmp_manager do |manager|
      response = manager.get(campos.values)
      result = {}
      response.each_varbind do |vb|
        result.merge!(campos.key(vb.name.to_s) => vb.value)
      end
      result
    end
  end

  def google_maps_pins
    result = 'markers=color:blue%7Clabel:C'
    conexoes.each do |cnx|
      if cnx.latitude.present?
        result += '|' + cnx.latitude.to_s + ',' + cnx.longitude.to_s
      end
    end
    result
  end

  def lista_ips
    ips = []
    ip_redes.each do |rede|
      ips += rede.to_a
    end
    ips
  end

  def ips_disponiveis
    ips = []
    ip_redes.each do |rede|
      ips += rede.ips_disponiveis
    end
    ips
  end

  private

  def snmp_manager
    SNMP::Manager.open(
      host: ip.to_s,
      community: 'public',
      port: 161,
      version: :SNMPv1
    )
  end
end
