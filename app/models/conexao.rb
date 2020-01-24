class Conexao < ApplicationRecord
  belongs_to :pessoa
  belongs_to :plano
  belongs_to :ponto
  has_one :servidor, through: :ponto
  scope :bloqueado, -> { where("bloqueado") }

  def status_hotspot
    self.servidor.mk_command(['/ip/hotspot/active/print', '?user='+self.usuario.to_s])[0][0]
  end
end
