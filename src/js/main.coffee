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

class Amostra
    constructor: ->
        @dataHoraCriacao = Date.now()
        @numamostra = getId('numAmostra')
        @exame = EXAMES[Math.floor(Math.random() * 4)]

    set_result: ->
        @result = @exame.result[Math.floor(Math.random() * (@exame.result.length - 1))]
        @alterado = @result not in @exame.ref
        @dataHoraResultado = Date.now()


class Lote

    constructor: (@func) ->
        @timeout_status()
        @amostras = []
        @numlote = getId('numlote')
        @status = 'CRIADO'

    addAmostra: (am) ->
        @amostras.push(am)

    timeout_status: ->
        setTimeout =>
            @set_status()
        , 5000

    set_status: ->
        if @status == 'CRIADO'
            @status = 'EMPROCESSO'
            console.log("set_status: #{@status}")
        @processa_amostra(0)

    processa_amostra: (i) ->
        if i < @amostras.length
            am = @amostras[i]
            setTimeout =>
                am.set_result()
                @processa_amostra(++i)
            , Math.floor(Math.random() * 100)
        else
            @status = 'PRONTO'
            @processa_lote(this)

    processa_lote: (p) ->
        @func p


loteAberto = ''
lotesEmProcesso = []
lotesProntos = []
parar = true

processa_lote = (lote) ->
    i = lotesEmProcesso.indexOf(lote)
    lotesEmProcesso.pop(lotesProntos.push(lotesEmProcesso[i]))


add_lote_aberto = ->
    loteAberto = new Lote(processa_lote)

add_amostra = ->
    new Amostra

add_lote_amostra = ->
    if loteAberto.status == 'EMPROCESSO'
        lotesEmProcesso.push(loteAberto)
        add_lote_aberto()

    if loteAberto == ''
        add_lote_aberto()

    loteAberto.addAmostra(add_amostra())

    if not parar
        setTimeout(add_lote_amostra, Math.floor(Math.random() * 3000))


inicia = ->
    if parar
        parar = false
        add_lote_amostra()
    else
        parar = true


########################################################################################################################


$(document).ready ->
#  $('#btnTeste').on('click', $.proxy(cal.fire, this, 'abacate'))
    $('#btnAdAmotra').click(inicia)
    $('#btnZerar').click(resetStore)




