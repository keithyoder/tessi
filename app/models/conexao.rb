class Conexao < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  belongs_to :ponto
  has_one :servidor, through: :ponto
  has_many :conexao_enviar_atributos, dependent: :delete_all
  has_many :conexao_verificar_atributos, dependent: :delete_all
  has_many :autenticacoes, :primary_key => :usuario, :foreign_key => :username
  scope :bloqueado, -> { where("bloqueado") }

  after_touch :save
  after_save do
    if self.usuario.present? && self.senha.present?
      atr = ConexaoVerificarAtributo.where(conexao: self, atributo: 'Cleartext-Password').first_or_create
      atr.op = ':='
      atr.valor = self.senha
      atr.save
    end

    if self.ponto.tecnologia == "Radio"
      atr = ConexaoVerificarAtributo.where(conexao: self, atributo: 'Mikrotik-Host-Ip').first_or_create
      atr.op = ':='
      atr.valor = self.ip.to_s
      atr.save
    end
  end

  def status_hotspot
    result = self.servidor.mk_command(['/ip/hotspot/active/print', '?user='+self.usuario.to_s])
    if result.present?
      result[0][0]
    else
      ['uptime' => "Desconectado"]
    end
  end
end
