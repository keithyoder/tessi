class Servidor < ApplicationRecord
  def uptime
    tk = MTik::Connection.new(:host => self.ip.to_s, :user => self.usuario, :pass => self.senha)
    tk.fetch(ARGV[3]) do |status, total, bytes|
      puts "fetch status: #{status} -- #{bytes} bytes of #{total} downloaded..."
    end
    tk.close
  end
end
