(function() {
  var IN, OUT, ausgabe, bruttoBerechnen, eingabe, mwstBerechnen, nettoBerechnen;

  IN = process.stdin;

  IN.resume();

  IN.setEncoding('utf8');

  OUT = process.stdout;

  ausgabe = function(output) {
    return OUT.write('Brutto: ' + output + '\n');
  };

  eingabe = function(chunk) {
    return parseFloat(chunk);
  };

  nettoBerechnen = function(newNetto) {
    return arguments.callee.netto += newNetto;
  };

  mwstBerechnen = function(netto) {
    return netto * arguments.callee.mwst;
  };

  bruttoBerechnen = function(netto, steuer) {
    return netto + steuer;
  };

  nettoBerechnen.netto = 0.0;

  mwstBerechnen.mwst = 0.19;

  IN.on('data', function(chunk) {
    var brutto, input, mwst, netto;
    input = eingabe(chunk);
    netto = nettoBerechnen(input);
    mwst = mwstBerechnen(netto);
    brutto = bruttoBerechnen(netto, mwst);
    return ausgabe(brutto);
  });

  console.log('running....\n');

}).call(this);
