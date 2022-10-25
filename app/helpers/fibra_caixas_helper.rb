# frozen_string_literal: true

module FibraCaixasHelper
  def markers
    markers = ["markers=color:blue%7Clabel:C|#{@fibra_caixa.latitude},#{@fibra_caixa.longitude}"]
    @fibra_caixa.conexoes.where.not(latitude: nil, longitude: nil).each do |c|
      markers.append("markers=label:#{c.porta}|#{c.latitude},#{c.longitude}")
    end
    markers.join('&')
  end
end
