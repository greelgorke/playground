# einlesen + ausgeben
IN = process.stdin
IN.resume()
IN.setEncoding 'utf8'
OUT = process.stdout

ausgabe = (output)->
	OUT.write 'Brutto: '+ output + '\n'

eingabe = (chunk)->
	parseFloat chunk

# FUs
nettoBerechnen = (newNetto)-> arguments.callee.netto += newNetto
mwstBerechnen = (netto)-> netto * arguments.callee.mwst
bruttoBerechnen = (netto, steuer)-> netto + steuer

#configurieren
nettoBerechnen.netto = 0.0
mwstBerechnen.mwst = 0.19

# verdratung und ready
IN.on 'data', (chunk)->
	input = eingabe chunk
	netto = nettoBerechnen input
	mwst = mwstBerechnen netto
	brutto = bruttoBerechnen netto, mwst
	ausgabe brutto

console.log 'running....\n'
