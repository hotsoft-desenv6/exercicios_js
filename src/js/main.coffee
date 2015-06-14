resetStore = ->
    localStorage.clear()
id = 0

getId = (cod) ->
    id = id + 1
###
id = localStorage.getItem(cod)
if id == null
  id = 1
  localStorage.setItem(cod, id)
localStorage.setItem(cod, parseInt(id) + 1)
id
###
class Base
    constructor: (@ms, @func) ->
        @exec_func()

    exec_func: ->
        setTimeout =>
            @p_func()
        , @ms

    p_func: ->
        @func()

class Amostra #extends Base
    constructor: ->
        @dataCriacao = Date.now()
        @idAmostra = getId('numAmostra')

class Lote extends Base
    amostras = []

    constructor: ->
        super
        @numlote = getId('numlote')
        @status ='CRIADO'

    addAmostra: (am) ->
        amostras.push(am)
        console.log("Lote: #{@numlote} - Status: #{@status} - Amostra: #{ amostras[amostras.length-1].idAmostra}")

add_lote = ->
    new Lote( 5000,
        ->
            loteAberto.status = 'EMPROCESSO'
    )

add_amostra = ->
    new Amostra

loteAberto = ''
loteEmProcesso = []
add_lote_amostra = ->
    if loteAberto.status == 'EMPROCESSO'
        loteEmProcesso.push(loteAberto)
        console.log("Lote: #{loteEmProcesso[loteEmProcesso.length-1].numlote} - Status:
                                        #{loteEmProcesso[loteEmProcesso.length-1].status}")
        loteAberto = add_lote()

    if loteAberto == ''
        loteAberto = add_lote()

    loteAberto.addAmostra(add_amostra())

inicia = ->
    setInterval(add_lote_amostra, 1000)

inicia()

########################################################################################################################

###

$(document).ready ->
#  $('#btnTeste').on('click', $.proxy(cal.fire, this, 'abacate'))
  $('#btnZerar').click(resetStore)
  $('#btnAdAmotra').click(inicia)

###