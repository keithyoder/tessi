class IpRede < ApplicationRecord
  belongs_to :ponto
  
  def cidr
    rede.to_string + '/' + rede.prefix().to_s if rede != nil
  end

  def ips_disponiveis
    rede.to_range().count - 4
  end

  def conexoes
    Conexao.rede_ip(cidr)
  end
end
