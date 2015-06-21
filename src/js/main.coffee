CRIADO = "CRIADO"
EM_PROCESSO = "EMPROCESSO"
PRONTO = "PRONTO"

log = (t) ->
    console.log(t)

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
        @resultado = @exame.result[Math.floor(Math.random() * (@exame.result.length - 1))]
        @alterado = @resultado not in @exame.ref
        @dataHoraResultado = Date.now()

class Lote
    constructor: ->
        @amostras = []
        @numlote = getId('numlote')
        @status = CRIADO

    setStatus: (s) ->
        @status = s

    addAmostra: (am) ->
        @amostras.push(am)


lotes = []
parar = true

add_lote_amostra = ->
    if lotes[lotes.length - 1]
        switch lotes[lotes.length - 1].status
            when CRIADO
                add_amostra()
            when EM_PROCESSO
                add_lote()
    else
        add_lote()

    if not parar
        setTimeout(add_lote_amostra, Math.floor(Math.random() * 7000))


add_lote = ->
    l = lotes[lotes.push(new Lote)-1]
    log('novo lote: '+l.numlote)

    i = 0
    processa_amostra = ->
        if i < l.amostras.length
            l.amostras[i++].set_result()
            setTimeout(processa_amostra, Math.floor(Math.random() * 3000))
        else
            l.setStatus(PRONTO)

        log('lote: '+l.numlote +
            ' - status: '+ l.status +
            ' - amostra: '+ l.amostras[i-1].numamostra +
            ' - exame: ' + l.amostras[i-1].exame.nome +
            ' - resultado: '+ l.amostras[i-1].resultado)

    processa_lote = ->
        l.setStatus(EM_PROCESSO)
        processa_amostra()

    setTimeout(processa_lote, 15000)

add_amostra = ->
    lotes[lotes.length - 1].addAmostra(new Amostra())

    llote = lotes[lotes.length - 1]
    lamostra = llote.amostras[llote.amostras.length-1]

    log('numlote: '+ llote.numlote +
        ' - numamostra: ' + lamostra.numamostra +
        ' - exame: '+lamostra.exame.nome)

inicia = ->
    log('inicia')
    if parar
        parar = false
        add_lote_amostra()
    else
        parar = true


########################################################################################################################

$(document).ready ->
#  $('#btnTeste').on('click', $.proxy(cal.fire, this, 'abacate'))
    $('#btnAdAmotra').click(inicia)
    $('#teste').click(resetStore)