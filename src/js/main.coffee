resetStore = ->
  localStorage.clear()

getId = (cod) ->
  id = localStorage.getItem(cod)
  if id == null
    localStorage.setItem(cod, 0)
    id = 0
  localStorage.setItem(cod, parseInt(id) + 1)
  id

class Amostra
  constructor: -> #(@exame, @valRef) ->
    dataCriacao = Date.now()
    $('#loteAmostras').append('<tr><th>' + getId('numAmostra') + '</th><th>' + dataCriacao + '</th>')

class Lote
  @Amostras = {}

  constructor: ->
    setStatus('CRIADO')
    numlote = getId('numlote')
    $('#painelLote').css('display', 'block')
    $('#loteNum').text('Lote: '+ numlote)

    scep = -> setStatus('EM PROCESSO')

    setTimeout(scep , 5000)

  setStatus: (st) ->
    @status = st

  addAmostra: (am) ->
    @Amostras.append(am)

inicia = ->
  setInterval(adiciona_amostra, 3000)

@loteAberto = ''
adiciona_amostra = ->
  if @loteAberto == ''
    @loteAberto = new Lote()

  @loteAberto.addAmostra(new Amostra())


########################################################################################################################
$(document).ready ->
#  $('#btnTeste').on('click', $.proxy(cal.fire, this, 'abacate'))
  $('#btnTeste').click(resetStore)
  $('#btnAdAmotra').click(inicia)



