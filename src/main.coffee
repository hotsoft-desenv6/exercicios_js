class Amostra
  constructor: (@exame, @valRef) ->
    dataCriacao = Date.now()


class Lote
  @emProcesso = {}
  @processado = {}

  constructor: ->
    @status = 'CRIADO'

  addAmostra: (amostra) ->
    emProcesso.add(amostra)
    if @status == 'CRIADO'
      @status = 'EMPROCESSO'








########################################################################################################################
alerta = (v) ->
  alert(v)

$(document).ready ->
  $("#btnTeste").on("click", $.proxy(alerta, this, "abacate"))
  $("#btnAdAmotra").click(alerta)
