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

window.initMap = ->
  # The location of Uluru
  alagoinha = 
    lat: -8.580522
    lng: -36.761072
  # The map, centered at Uluru
  conexoes = $('#map').data 'conexoes'
  map = new (google.maps.Map)(document.getElementById('map'))
  map.fitBounds(getBounds(conexoes))
  # The marker, positioned at Uluru
  for conexao in conexoes
    position =
      lat: parseFloat(conexao.latitude)
      lng: parseFloat(conexao.longitude)
    marker = new (google.maps.Marker)(
      position: position
      map: map)
  return
