CRIADO = "CRIADO"
EM_PROCESSO = "EMPROCESSO"
PRONTO = "PRONTO"

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
        console.log("#{@exame.nome} - #{@resultado}")


class Lote
    constructor: ->
        @amostras = []
        @numlote = getId('numlote')
        @status = CRIADO

    setStatus: (s) ->
        console.log("#{@numlote} - #{@status}")
        @status = s

    addAmostra: (am) ->
        @amostras.push(am)
        console.log(" #{@amostras[@amostras.length - 1].numamostra} - #{@amostras[@amostras.length - 1].exame.nome}")


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
    l = lotes.push(new Lote)
    console.log('lote: ' + l.numlote)
    setTimeout ->
        l.setStatus(EM_PROCESSO)
        processa_amostra()
    , 12000

    processa_lote: ->
        l.setStatus(EM_PROCESSO
          processa_amostra

        i = 0
        processa_amostra: ->
            if i <= l.amostras.length
                l.amostras[i++].set_result()
                setTimeout(processa_amostra(), Math.floor(Math.random() * 3000))
            else
                console.log(l.status = PRONTO)

add_amostra = ->
    lotes[lotes.length - 1].addAmostra(new Amostra())

inicia = ->
    console.log('inicia')
    if parar
        parar = false
        add_lote_amostra()
    else
        parar = true


########################################################################################################################

$(document).ready ->
#  $('#btnTeste').on('click', $.proxy(cal.fire, this, 'abacate'))
    $('#btnAdAmotra').click(inicia)