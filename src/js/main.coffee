CRIADO = "CRIADO"
EM_PROCESSO = "EMPROCESSO"
PRONTO = "PRONTO"

TEMPO_ADD_AMOSTRA = 3000
TEMPO_LOTE_ABERT0 = 10000
TEMPO_PROCESSA_AMOSTRA = 10000

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
    if not parar
        if lotes[lotes.length - 1]
            switch lotes[lotes.length - 1].status
                when CRIADO
                    add_amostra()
                when EM_PROCESSO
                    add_lote()
                when PRONTO
                    add_lote()
        else
            add_lote()

        setTimeout(add_lote_amostra, Math.floor(Math.random() * TEMPO_ADD_AMOSTRA))


add_lote = ->
    l = lotes[lotes.push(new Lote)-1]
    log('novo lote: '+l.numlote)
    add_div_lote(l)

    i = 0
    processa_amostra = ->
        if i < l.amostras.length
            a = l.amostras[i++]
            a.set_result()
            add_resultado(l, a)
            setTimeout(processa_amostra, Math.floor(Math.random() * TEMPO_PROCESSA_AMOSTRA))
        else
            l.setStatus(PRONTO)
            div_lote_pronto(l)

        log('lote: '+l.numlote +
            ' - status: '+ l.status +
            ' - amostra: '+ l.amostras[i-1].numamostra +
            ' - exame: ' + l.amostras[i-1].exame.nome +
            ' - resultado: '+ l.amostras[i-1].resultado)

    processa_lote = ->
        l.setStatus(EM_PROCESSO)
        div_lote_em_processo(l)
        processa_amostra()

    setTimeout(processa_lote, TEMPO_LOTE_ABERT0)

add_amostra = ->
    lotes[lotes.length - 1].addAmostra(new Amostra())

    llote = lotes[lotes.length - 1]
    lamostra = llote.amostras[llote.amostras.length-1]
    add_div_amostra(llote, lamostra)

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
    resetStore()
    $('#btnAddAmotra').click ->
        inicia()
        if $(this).text() == 'Iniciar'
            $(this).text('Pausar').removeClass("btn-success").addClass("btn-danger")
        else
            $(this).text('Iniciar').removeClass("btn-danger").addClass("btn-success")

add_div_lote = (l) ->
    $(".lote_aberto").append($(".lote-ex").clone().removeClass("lote-ex").addClass("lote-#{l.numlote}"))
    $(".lote-#{l.numlote}").find(".lote_tit").text("Lote: #{l.numlote}")
    $(".lote-#{l.numlote}").find(".amostras").removeClass("amostras").addClass("amostras-lote-#{l.numlote}")


add_div_amostra = (l, a) ->
    $(".amostras-lote-#{l.numlote}").append("<tr class='amostra-#{a.numamostra}'><td>#{a.numamostra}
                                                            </td><td>#{a.exame.nome}</td></tr>")

div_lote_em_processo = (l) ->
    $(".lotes_em_processo").append($(".lote-#{l.numlote}"))
    $(".lote-#{l.numlote}").find("tr[name=lote]").append("<th>Resultado</th><th>Data</th>")

    $(".lote-#{l.numlote}").find("tbody").find("tr").append("<td name='resultado'></td><td name='dt'></td>")


div_lote_pronto = (l) ->
    $(".lotes_prontos").append($(".lote-#{l.numlote}"))

add_resultado = (l, a) ->
    if a.alterado
        $(".amostra-#{a.numamostra}").addClass("alert alert-danger")
    else
        $(".amostra-#{a.numamostra}").addClass("alert alert-success")

    dt = $.format.date(a.dataHoraResultado, 'dd/MM/yyyy HH:mm:ss')
    $(".amostra-#{a.numamostra}").find("td[name=resultado]").text("#{a.resultado}")
    $(".amostra-#{a.numamostra}").find("td[name=dt]").text("#{dt}")
    $("td:contains('true')").text('Positivo')
    $("td:contains('false')").text('Negativo')
