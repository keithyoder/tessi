class Servidor < ApplicationRecord
  def ppp_users
    begin
      users = MTik::command(:host => self.ip.to_s, :user => self.usuario, :pass => self.senha, :unencrypted_plaintext => :true, :command => '/ppp/active/print').to_json
      users[0].count.to_s
    rescue StandardError => e  
      e.message
    end
  end

end
