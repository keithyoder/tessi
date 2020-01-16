class Servidor < ApplicationRecord
  def ppp_users
    begin
      users = MTik::command(:host => '10.200.8.34', :user => 'admin', :pass => '010407kry', :unencrypted_plaintext => :true, :command => '/ppp/active/print').to_json
      users[0].count
    rescue
      puts "Error"
    end
  end

end
