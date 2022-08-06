# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

int2ip = (ipInt) ->
  (ipInt >>> 24) + '.' + (ipInt >> 16 & 255) + '.' + (ipInt >> 8 & 255) + '.' + (ipInt & 255)

getBounds = (conexoes) ->
  bounds = new google.maps.LatLngBounds()
  for conexao in conexoes
    position = new google.maps.LatLng(
      parseFloat(conexao.latitude),
      parseFloat(conexao.longitude)
    )
    bounds.extend(position)
  return bounds

infoWindow = (conexao) ->
  infowindow = new google.maps.InfoWindow({
    content: "<h4><a href=/conexoes/#{conexao.id}>#{conexao.pessoa.nome}</a></h4>" +
    "<div id='bodyContent'>#{conexao.logradouro.nome}, #{conexao.pessoa.numero} - #{conexao.bairro.nome}<br>"+
    "#{conexao.ponto.nome} - #{int2ip(conexao.ip.addr)}</div>"
  })

criarMarker = (map, conexao, conectada) ->
  position =
    lat: parseFloat(conexao.latitude)
    lng: parseFloat(conexao.longitude)
  if conectada
    label = ''
  else
    label = 'D'

  marker = new (google.maps.Marker)(
    position: position,
    map: map,
    label: label
  )
  marker.addListener 'click', () =>
    infoWindow(conexao).open(map, marker)

window.initMap = ->
  conexoes = $('#map').data 'conexoes'
  map = new (google.maps.Map)(document.getElementById('map'))
  map.fitBounds(getBounds(conexoes))
  for conexao in conectadas
    criarMarker(map, conexao, true)
  for conexao in deconectadas
    criarMarker(map, conexao, false)
  return
