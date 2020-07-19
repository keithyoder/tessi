class IpRede < ApplicationRecord
  belongs_to :ponto

  def cidr
    rede.to_string + '/' + rede.prefix().to_s if rede != nil
  end
end
