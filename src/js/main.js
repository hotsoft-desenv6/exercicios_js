// Generated by CoffeeScript 1.9.2
(function() {
  var Amostra, Lote, adiciona_amostra, resetStore;

  Amostra = (function() {
    function Amostra(exame, valRef) {
      var dataCriacao;
      this.exame = exame;
      this.valRef = valRef;
      dataCriacao = Date.now();
    }

    return Amostra;

  })();

  Lote = (function() {
    var getNumLote, setStatus;

    Lote.emProcesso = {};

    Lote.processado = {};

    getNumLote = function() {
      var numLote;
      numLote = localStorage.getItem('numLote');
      if (numLote === null) {
        localStorage.setItem('numLote', 0);
        numLote = 0;
      }
      localStorage.setItem('numLote', parseInt(numLote) + 1);
      return numLote;
    };

    setStatus = function(st) {
      var nlote;
      this.status = st;
      nlote = getNumLote();
      return $('#loteAberto').append('<tr><th>' + nlote + '</th><th>' + this.status + '</th>');
    };

    function Lote() {
      var scep;
      scep = function() {
        return setStatus('EMPROCESSO');
      };
      setInterval(scep, 2000);
    }

    return Lote;

  })();

  adiciona_amostra = function() {
    var l;
    return l = new Lote();
  };

  resetStore = function() {
    return localStorage.clear();
  };

  $(document).ready(function() {
    $('#btnTeste').click(resetStore);
    return $('#btnAdAmotra').click(adiciona_amostra);
  });

}).call(this);

//# sourceMappingURL=main.js.map
