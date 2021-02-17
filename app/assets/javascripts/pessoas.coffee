# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  new Cleave('#pessoa_telefone1', {
    phone: true,
    phoneRegionCode: 'br'
  })
  new Cleave('#pessoa_telefone2', {
    phone: true,
    phoneRegionCode: 'br'
  })
