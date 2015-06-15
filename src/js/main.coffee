resetStore = ->
    localStorage.clear()

getId = (cod) ->
    id = localStorage.getItem(cod)
    if id == null
        id = 1
        localStorage.setItem(cod, id)
    localStorage.setItem(cod, parseInt(id) + 1)
    id

EXAMES = [
    {nome: 'Glicose', tipo: 'Numerico', result: [100..300], ref: [150..250]},
    {nome: 'HIV', tipo: 'Boolean', result: [true, false], ref: false},
    {nome: 'Creatinina', tipo: 'Numerico', result: [20..50], ref: [30..40]},
    {nome: 'Triglicerideos', tipo: 'Numerico', result: [200..500], ref: [300..400]}
]

class Base
    constructor: (@f, @ms) ->
        @exec_f()

    exec_f: ->
        setTimeout =>
            @p_func()
        , @ms

    p_func: ->
        @f()

class Amostra #extends Base
    constructor: ->
        @dataCriacao = Date()
        @numamostra = getId('numAmostra')
        @exame = EXAMES[Math.floor(Math.random() * 4)]
        console.log(@exame.nome)

    set_result: ->
        @result = @exame.result[Math.floor(Math.random() * (@exame.result.length - 1))]
        @alterado = @result not in @exame.ref


class Lote extends Base
    amostras = []
    constructor: ->
        super
        @numlote = getId('numlote')
        @status = 'CRIADO'

    addAmostra: (am) ->
        amostras.push(am)

angular.module 'LoteApp', []
.controller 'LoteAbertoCtrl', () ->
    lotes = this

    lotes.loteAberto = ''
    lotes.loteEmProcesso = []

    add_lote = ->
        new Lote ->
            this.status = 'EMPROCESSO'
        , 5000

    add_amostra = ->
        new Amostra

    lotes.add_lote_amostra = ->
        if lotes.loteAberto.status == 'EMPROCESSO'
            lotes.loteEmProcesso.push(lotes.loteAberto)
            lotes.loteAberto = add_lote()

        if lotes.loteAberto == ''
            lotes.loteAberto = add_lote()

        lotes.loteAberto.addAmostra(add_amostra())
        console.log(lotes.loteAberto.numlote)

    lotes.inicia = ->
        console.log('inicia')
        setInterval(lotes.add_lote_amostra, 1000)




########################################################################################################################

###

$(document).ready ->
#  $('#btnTeste').on('click', $.proxy(cal.fire, this, 'abacate'))
  $('#btnZerar').click(resetStore)
  $('#btnAdAmotra').click(inicia)

###