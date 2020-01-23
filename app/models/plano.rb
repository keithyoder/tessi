require 'csv'

class Plano < ApplicationRecord
  has_many :plano_verificar_atributos
  has_many :plano_enviar_atributos
  has_many :conexoes

  after_save do
    atr = PlanoEnviarAtributo.where(plano: self, atributo: 'Mikrotik-Rate-Limit').first_or_create
    atr.op = '='
    atr.valor = self.mikrotik_rate_limit
    atr.save
  end

  after_create do
    atr = PlanoEnviarAtributo.where(plano: self, atributo: 'Acct-Interim-Interval').first_or_create
    atr.op = ':='
    atr.valor = '900'
    atr.save

    atr = PlanoVerificarAtributo.where(plano: self, atributo: '	Simultaneous-Use').first_or_create
    atr.op = ':='
    atr.valor = '1'
    atr.save
  end

  def self.to_csv
    attributes = %w{id nome mensalidade download upload burst}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |plano|
        csv << attributes.map{ |attr| plano.send(attr) }
      end
    end
  end

  def velocidade
    self.download.to_s + 'M ▼ / ' + self.upload.to_s + 'M ▲'
  end

  def mikrotik_rate_limit
    if self.burst
      burstup = (self.upload*1024*1.1).to_i
      burstdown = (self.download*1024*1.1).to_i
    else
      burstup = self.upload * 1024
      burstdown = self.download * 1024
    end
    '%{upload}M/%{download}M %{burstup}K/%{burstdown}K %{upload}M/%{download}M 60/60 8 %{upload}M/%{download}M' %
      {upload: self.upload, download: self.download, burstup: burstup, burstdown: burstdown}
  end

  def burst_as_string
    if self.burst?
      "Ativiado"
    else
      "Desativado"
    end
  end
end
