# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.carregarConexoes = ->
  pessoa = $("#os_pessoa_id").val()
  $.ajax
    url: "/pessoas/#{pessoa}.json?conexoes"
    method: 'GET'
    dataType: 'json'
    error: (xhr, status, error) ->
      console.error 'AJAX Error: ' + status + error
      return
    success: (response) ->
      conexoes = response
      $("#os_conexao_id").empty()
      $("#os_conexao_id").append("<option value=''>--Escolher Conexão--</option>")
      for conexao in conexoes
        $("#os_conexao_id").append("<option value=#{conexao.id}>#{conexao.ip} - #{conexao.usuario}</option>")
      return
  return
