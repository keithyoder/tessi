# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.initMap = ->
  # The location of Uluru
  alagoinha = 
    lat: -8.580522
    lng: -36.761072
  # The map, centered at Uluru
  map = new (google.maps.Map)(document.getElementById('map'),
    zoom: 13
    center: alagoinha)
  # The marker, positioned at Uluru
  conexoes = $('#map').data 'conexoes'
  for conexao in conexoes
    position =
      lat: parseFloat(conexao.latitude)
      lng: parseFloat(conexao.longitude)
    marker = new (google.maps.Marker)(
      position: position
      map: map)
  return
