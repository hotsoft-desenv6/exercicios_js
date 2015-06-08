class Amostra
  constructor: (@exame, @valRef) ->
    dataCriacao = Date.now()

class Lote
  @emProcesso = {}
  @processado = {}

  getNumLote = ->
    numLote = localStorage.getItem('numLote')

    if numLote == null
      localStorage.setItem('numLote', 0)
      numLote = 0

    localStorage.setItem('numLote', parseInt(numLote) + 1)
    numLote

  setStatus = (st) ->
    @status = st
    nlote = getNumLote()
    $('#loteAberto').append('<tr><th>' + nlote + '</th><th>' + @status + '</th>')

  constructor: ->
#    setStatus('CRIADO')
    scep = -> setStatus('EMPROCESSO')
    setInterval(scep , 2000)


adiciona_amostra = ->
  l = new Lote()

resetStore = ->
  localStorage.clear()


########################################################################################################################
$(document).ready ->
#  $('#btnTeste').on('click', $.proxy(cal.fire, this, 'abacate'))
  $('#btnTeste').click(resetStore)
  $('#btnAdAmotra').click(adiciona_amostra)



