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
        console.log("Amostra: #{@numamostra} - Exame: #{@exame.nome} - Res: #{@result} - Alterasdo: #{@alterado}")


class Lote
    this.a = 0
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
        , 18000

    set_status: ->
        if @status == 'CRIADO'
            @status = 'EMPROCESSO'
            console.log("em processo - #{@numlote}")
        @processa_amostra()

    processa_amostra: ->
        console.log( @a + ' - ' + @amostras.length)
        console.log( @a <= @amostras.length)

        if @a <= @amostras.length
            setTimeout ->
                @amostras[@a].set_result()
                @processa_amostra
                @a++
            , Math.floor(Math.random()*7000)
        else
            @status = 'PRONTO'
            console.log("pronto - #{@numlote}")
            @processa_lote()

    processa_lote: ->
        @func


loteAberto = ''
lotesEmProcesso = []
lotesProntos = []

processa_lote = ->
    for l in lotesEmProcesso
        console.log('lote em processo: ' +l.numlote)
        lotesProntos.push(l)
        lotesEmProcesso.pop(l)

add_lote = ->
    new Lote processa_lote

add_amostra = ->
    new Amostra

add_lote_amostra = ->
    if loteAberto.status == 'EMPROCESSO'
        lotesEmProcesso.push(loteAberto)
        loteAberto = add_lote()

    if loteAberto == ''
        loteAberto = add_lote()

    loteAberto.addAmostra(add_amostra())

    setTimeout(add_lote_amostra, Math.floor(Math.random() * 7000))
    console.log(loteAberto.numlote)


add_lote_amostra()

########################################################################################################################

###

$(document).ready ->
#  $('#btnTeste').on('click', $.proxy(cal.fire, this, 'abacate'))
  $('#btnZerar').click(resetStore)
  $('#btnAdAmotra').click(inicia)

###