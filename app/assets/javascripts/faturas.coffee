# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#fatura_liquidacao').change -> alert("Yayyy!!!")

calcular_total =(valor, juros, multa, desconto, vencimento, liquidacao) ->
  dias = Math.floor((liquidacao.getTime()-vencimento.getTime()) / (1000 * 3600 * 24))
  if dias > 0
    valor = (1+multa)*valor + (juros / 30 * dias) * valor
  else
    valor - desconto
