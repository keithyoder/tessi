# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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
    content: "<h4>#{conexao.pessoa.nome}</h4>" +
    "<div id='bodyContent'>#{conexao.logradouro.nome}, #{conexao.pessoa.numero} - #{conexao.bairro.nome}<br>"+
    "#{conexao.ip}</div>"
  })

criarMarker = (map, conexao) ->
  position =
    lat: parseFloat(conexao.latitude)
    lng: parseFloat(conexao.longitude)
  marker = new (google.maps.Marker)(
    position: position
    map: map
  )
  marker.addListener 'click', () =>
    infoWindow(conexao).open(map, marker)

window.initMap = ->
  conexoes = $('#map').data 'conexoes'
  map = new (google.maps.Map)(document.getElementById('map'))
  map.fitBounds(getBounds(conexoes))
  for conexao in conexoes
    criarMarker(map, conexao)
  return
