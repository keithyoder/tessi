# frozen_string_literal: true

class IpRede < ApplicationRecord
  belongs_to :ponto
  ransacker :rede_string do
    Arel.sql("rede::text")
  end

  def cidr
    "#{rede}/#{rede.prefix}" unless rede.nil?
  end

  def ips_quantidade
    if rede.ipv6?
      2**(56 - rede.prefix)
    else
      rede.to_range.count - 4
    end
  end

  def to_a
    return [] if rede.ipv6?

    rede.to_range.map(&:to_s)[3...-1]
  end

  def conexoes
    Conexao.rede_ip(cidr)
  end

  def ips_disponiveis
    ocupados = conexoes.map { |c| c.ip.to_s }
    to_a - ocupados
  end
end
