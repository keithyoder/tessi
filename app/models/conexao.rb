class Conexao < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  belongs_to :ponto
  belongs_to :caixa, :class_name => 'FibraCaixa', optional: true
  has_one :servidor, through: :ponto
  belongs_to :contrato
  has_one :cidade, through: :pessoa
  has_many :faturas, through: :contrato
  has_many :conexao_enviar_atributos, dependent: :delete_all
  has_many :conexao_verificar_atributos, dependent: :delete_all
  has_many :autenticacoes, :primary_key => :usuario, :foreign_key => :username
  has_many :rad_accts, :primary_key => :usuario, :foreign_key => :username
  scope :bloqueado, -> { where("bloqueado") }
  scope :ativo, -> { where("not bloqueado") }
  scope :inadimplente, -> { where("inadimplente") }
  scope :radio, -> { joins(:ponto).where(pontos: {tecnologia: :Radio}) }
  scope :fibra, -> { joins(:ponto).where(pontos: {tecnologia: :Fibra}) }
  scope :pessoa_fisica, -> { joins(:pessoa).where(pessoas: {tipo: "Pessoa Física"}) }
  scope :pessoa_juridica, -> { joins(:pessoa).where(pessoas: {tipo: "Pessoa Jurídica"}) }
  scope :ate_1M, -> { joins(:plano).where("planos.download <= 1")}
  scope :ate_2M, -> { joins(:plano).where("planos.download BETWEEN 1.01 AND 2")}
  scope :ate_8M, -> { joins(:plano).where("planos.download BETWEEN 2.01 AND 8")}
  scope :ate_12M, -> { joins(:plano).where("planos.download BETWEEN 8.01 AND 12")}
  scope :ate_34M, -> { joins(:plano).where("planos.download BETWEEN 12.01 AND 34")}
  scope :acima_34M, -> { joins(:plano).where("planos.download > 34")}
  enum tipo: {:Cobranca => 1, :Cortesia => 2, :Outro_3 => 3, :Outro_4 => 4, :Outros => 5}

  after_touch :save
  after_save do
    if self.usuario.present? && self.senha.present?
      atr = ConexaoVerificarAtributo.where(conexao: self, atributo: 'Cleartext-Password').first_or_create
      atr.op = ':='
      atr.valor = self.senha
      atr.save
    end

    if self.ponto.tecnologia == "Radio"
      ConexaoVerificarAtributo.where(conexao: self, atributo: 'Calling-Station-Id').destroy_all
      ConexaoEnviarAtributo.where(conexao: self, atributo: 'Framed-IP-Address').destroy_all
      atr = ConexaoVerificarAtributo.where(conexao: self, atributo: 'Mikrotik-Host-Ip').first_or_create
      atr.op = '=='
      atr.valor = self.ip.to_s
      atr.save
    end

    if self.ponto.tecnologia == "Fibra"
      ConexaoVerificarAtributo.where(conexao: self, atributo: 'Mikrotik-Host-Ip').destroy_all
      atr = ConexaoVerificarAtributo.where(conexao: self, atributo: 'Calling-Station-Id').first_or_create
      atr.op = '=='
      atr.valor = self.mac
      atr.save
      atr = ConexaoEnviarAtributo.where(conexao: self, atributo: 'Framed-IP-Address').first_or_create
      atr.op = ':='
      atr.valor = self.ip.to_s
      atr.save
    end

  end

  after_update do
    if self.saved_change_to_plano_id? || self.saved_change_to_bloqueado? || self.saved_change_to_inadimplente?
      self.desconectar_hotspot
    end
  end

  def self.to_csv
    attributes = %w{id Pessoa Plano Ponto IP}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |conexao|
        csv << [conexao.id, conexao.pessoa.nome, conexao.plano.nome, conexao.ponto.nome, conexao.ip]
      end
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

  def desconectar_hotspot
    if self.ponto.tecnologia == :Radio
      id = self.servidor.mk_command(['/ip/hotspot/active/print', '?user='+self.usuario.to_s])[0][0][".id"]
      result = self.servidor.mk_command(['/ip/hotspot/active/remove', '=.id='+id])
    end
  end

end
