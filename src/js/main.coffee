class Amostra
  constructor: (@exame, @valRef) ->
    dataCriacao = Date.now()
    $('#loteAmostras').append('<tr><th>' + numAmostra + '</th><th>' + @exame + '</th>')

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


  constructor: ->
    setStatus('CRIADO')
    numlote = getNumLote()
    $('#painelLote').css('display', 'block')
    $('#loteNum').text('Lote: '+ numlote)

    scep = -> setStatus('EM PROCESSO')
    setTimeout(scep , 2000)


adiciona_amostra = ->
  l = new Lote()

resetStore = ->
  localStorage.clear()


########################################################################################################################
$(document).ready ->
#  $('#btnTeste').on('click', $.proxy(cal.fire, this, 'abacate'))
  $('#btnTeste').click(resetStore)
  $('#btnAdAmotra').click(adiciona_amostra)



