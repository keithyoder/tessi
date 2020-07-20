class IpRede < ApplicationRecord
  belongs_to :ponto
  
  def cidr
    rede.to_string + '/' + rede.prefix().to_s if rede != nil
  end

  def ips_quantidade
    rede.to_range().count - 4
  end

  def to_a 
    rede.to_range().map(&:to_s)[3...-1]
  end

  def conexoes
    Conexao.rede_ip(cidr)
  end

  def ips_disponiveis
    ocupados = conexoes.map { |c| c.ip.to_s }
    to_a - ocupados
  end
end
