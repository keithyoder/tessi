class Servidor < ApplicationRecord
  scope :ativo, -> { where("ativo") }

  def ppp_users
    begin
      users = MTik::command(:host => self.ip.to_s, :user => self.usuario,
        :pass => self.senha, :unencrypted_plaintext => :true, :command => '/ppp/active/print')
      (users[0].count - 1).to_s
    rescue StandardError => e  
      e.message
    end
  end

  def hotspot_users
    begin
      users = MTik::command(:host => self.ip.to_s, :user => self.usuario,
        :pass => self.senha, :unencrypted_plaintext => :true, :command => '/ip/hotspot/active/print')
      (users[0].count - 1).to_s
    rescue StandardError => e  
      e.message
    end
  end

  def ping?
    check = Net::Ping::External.new(self.ip.to_s)
    check.ping?
  end
end
