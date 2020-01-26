class Conexao < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  belongs_to :ponto
  has_one :servidor, through: :ponto
  has_many :conexao_enviar_atributos
  has_many :conexao_verificar_atributos
  has_many :autenticacoes, :primary_key => :usuario, :foreign_key => :username
  scope :bloqueado, -> { where("bloqueado") }

  after_touch :save
  after_save do
    atr = ConexaoVerificarAtributo.where(conexao: self, atributo: 'Cleartext-Password').first_or_create
    atr.op = ':='
    atr.valor = self.senha
    atr.save
  end

  def status_hotspot
    self.servidor.mk_command(['/ip/hotspot/active/print', '?user='+self.usuario.to_s])[0][0]
  end
end
