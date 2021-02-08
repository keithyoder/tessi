# frozen_string_literal: true

class Conexao < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  belongs_to :ponto
  belongs_to :caixa, class_name: 'FibraCaixa', optional: true
  has_one :servidor, through: :ponto
  belongs_to :contrato, optional: true
  has_one :cidade, through: :pessoa
  has_many :faturas, through: :contrato
  has_many :conexao_enviar_atributos, dependent: :delete_all
  has_many :conexao_verificar_atributos, dependent: :delete_all
  has_many :autenticacoes, primary_key: :usuario, foreign_key: :username
  has_many :rad_accts, primary_key: :usuario, foreign_key: :username
  scope :bloqueado, -> { where('bloqueado') }
  scope :ativo, -> { where('not bloqueado') }
  scope :conectada, -> { select('conexoes.*').distinct.joins(:rad_accts).where('AcctStartTime > ? and AcctStopTime is null', 2.days.ago) }
  scope :inadimplente, -> { where('inadimplente') }
  scope :radio, -> { joins(:ponto).where(pontos: { tecnologia: :Radio }) }
  scope :fibra, -> { joins(:ponto).where(pontos: { tecnologia: :Fibra }) }
  scope :pessoa_fisica, -> { joins(:pessoa).where(pessoas: { tipo: 'Pessoa Física' }) }
  scope :pessoa_juridica, -> { joins(:pessoa).where(pessoas: { tipo: 'Pessoa Jurídica' }) }
  scope :ate_1M, -> { joins(:plano).where('planos.download <= 1') }
  scope :ate_2M, -> { joins(:plano).where('planos.download BETWEEN 1.01 AND 2') }
  scope :ate_8M, -> { joins(:plano).where('planos.download BETWEEN 2.01 AND 8') }
  scope :ate_12M, -> { joins(:plano).where('planos.download BETWEEN 8.01 AND 12') }
  scope :ate_34M, -> { joins(:plano).where('planos.download BETWEEN 12.01 AND 34') }
  scope :acima_34M, -> { joins(:plano).where('planos.download > 34')}
  enum tipo: { Cobranca: 1, Cortesia: 2, Outro_3: 3, Outro_4: 4, Outros: 5 }
  scope :rede_ip, ->(rede) { where('ip::inet << ?::inet', rede) }

  RADIUS_SENHA = 'Cleartext-Password'
  RADIUS_HOTSPOT_IP = 'Mikrotik-Host-Ip'
  RADIUS_PPPOE_IP = 'Framed-IP-Address'
  RADIUS_RATE_LIMIT = 'Mikrotik-Rate-Limit'

  validates_format_of :mac,
                      with: /\A([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}\z/i,
                      on: %i[create update],
                      message: 'Endereço MAC inválido'

  after_touch :save
  after_save do
    atualizar_senha
    atualizar_ip_e_mac
    atualizar_velocidade
  end

  after_commit do
    if saved_change_to_plano_id? ||
       saved_change_to_bloqueado? ||
       saved_change_to_inadimplente?
      desconectar
    end
  end

  def self.to_csv
    attributes = %w[id Pessoa Plano Ponto IP]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |conexao|
        csv << [
          conexao.id,
          conexao.pessoa.nome,
          conexao.plano.nome,
          conexao.ponto.nome,
          conexao.ip
        ]
      end
    end
  end

  def status_hotspot
    result = servidor.mk_command(['/ip/hotspot/active/print', "?user=#{usuario}"])
    if result.present?
      result[0][0]
    else
      ['uptime' => 'Desconectado']
    end
  end

  def desconectar
    Rails.logger.info "Desconectando usuario #{usuario}"
    if ponto.tecnologia == 'Radio'
      servidor.desconectar_hotspot(usuario)
    else
      servidor.desconectar_pppoe(usuario)
    end
  end

  def conectado
    rad_accts.where('AcctStartTime > ? and AcctStopTime is null', 2.days.ago)
             .count.positive?
  end

  private

  def atualizar_senha
    return unless usuario.present? && senha.present? && saved_change_to_senha?

    atr = conexao_verificar_atributos.where(atributo: RADIUS_SENHA).first_or_create
    atr.update!(op: ':=', valor: senha)
  end

  def atualizar_ip_e_mac
    return unless saved_change_to_ip? || saved_change_to_ponto_id? || saved_change_to_mac?

    if ponto.tecnologia == 'Radio'
      conexao_verificar_atributos.where(atributo: 'Calling-Station-Id').destroy_all
      conexao_enviar_atributos.where(atributo: RADIUS_PPPOE_IP).destroy_all
      atr = conexao_verificar_atributos.where(atributo: RADIUS_HOTSPOT_IP).first_or_create
      atr.update!(op: '==', valor: ip.to_s)
    elsif ponto.tecnologia == 'Fibra'
      conexao_verificar_atributos.where(atributo: RADIUS_HOTSPOT_IP).destroy_all
      atr = conexao_verificar_atributos.where(atributo: 'Calling-Station-Id').first_or_create
      atr.update!(op: '==', valor: mac)
      atr = conexao_enviar_atributos.where(atributo: RADIUS_PPPOE_IP).first_or_create
      atr.update!(op: ':=', valor: ip.to_s)
    end
  end

  def atualizar_velocidade
    return unless saved_change_to_velocidade?

    conexao_enviar_atributos.where(atributo: RADIUS_RATE_LIMIT).destroy_all
    return unless velocidade.present?

    atr = conexao_enviar_atributos.where(atributo: RADIUS_RATE_LIMIT).first_or_create
    atr.update!(op: '=', valor: velocidade)
  end
end
