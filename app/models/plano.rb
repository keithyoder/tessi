# frozen_string_literal: true

require 'csv'

class Plano < ApplicationRecord
  has_many :plano_verificar_atributos, dependent: :destroy
  has_many :plano_enviar_atributos, dependent: :destroy
  has_many :conexoes, dependent: :restrict_with_error
  scope :ativos, ->(plano_atual = nil) { where('ativo').or(Plano.where(id: plano_atual)) }

  after_save do
    atr = PlanoEnviarAtributo.where(plano: self, atributo: 'Mikrotik-Rate-Limit').first_or_create
    atr.op = '='
    atr.valor = mikrotik_rate_limit
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
    attributes = %w[id nome mensalidade download upload burst]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.find_each do |plano|
        csv << attributes.map { |attr| plano.send(attr) }
      end
    end
  end

  def velocidade
    "#{download}M ▼ / #{upload}M ▲"
  end

  def mikrotik_rate_limit
    if burst
      burstup = (upload * 1024 * 1.1).to_i
      burstdown = (download * 1024 * 1.1).to_i
    else
      burstup = upload * 1024
      burstdown = download * 1024
    end
    if download == 0
      format('1k/1k 1k/1k 1k/1k 60/60 8 1k/1k',
             upload: upload, download: download, burstup: burstup, burstdown: burstdown)
    else
      format('%<upload>sM/%<download>sM %<burstup>sK/%<burstdown>sK %<upload>sM/%<download>sM 60/60 8 %<upload>sM/%<download>sM',
             upload: upload, download: download, burstup: burstup, burstdown: burstdown)
      end
  end

  def burst_as_string
    if burst?
      'Ativiado'
    else
      'Desativado'
    end
  end

  def garantia
    if upload == download
      100
    else
      30
    end
  end
end
