getId = (cod) ->
  id = localStorage.getItem(cod)
  if id == null
    localStorage.setItem(cod, 0)
    id = 0
  localStorage.setItem(cod, parseInt(id) + 1)
  id

class Amostra
  constructor: (@exame, @valRef) ->
    dataCriacao = Date.now()
    $('#loteAmostras').append('<tr><th>' + numAmostra + '</th><th>' + @exame + '</th>')

class Lote
  @emProcesso = {}
  @processado = {}

  setStatus = (st) ->
    @status = st


  constructor: ->
    setStatus('CRIADO')
    numlote = getId('numlote')
    $('#painelLote').css('display', 'block')
    $('#loteNum').text('Lote: '+ numlote)

    scep = -> setStatus('EM PROCESSO')
    setTimeout(scep , 5000)


adiciona_amostra = ->
  l = new Lote()

resetStore = ->
  localStorage.clear()


########################################################################################################################
$(document).ready ->
#  $('#btnTeste').on('click', $.proxy(cal.fire, this, 'abacate'))
  $('#btnTeste').click(resetStore)
  $('#btnAdAmotra').click(adiciona_amostra)



