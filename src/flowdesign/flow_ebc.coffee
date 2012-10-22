###
generals
###
EventEmitter = require('events').EventEmitter

# einlesen + ausgeben
class UI
	constructor: ->
		IN = process.stdin
		IN.resume()
		IN.setEncoding 'utf8'
		OUT = process.stdout

		userinputEvent = new EventEmitter()
		userinputEventName = 'user input available'

		@wire = (handler)->
			userinputEvent.on userinputEventName, handler

		@write = (output)-> OUT.write 'Brutto: '+ output + '\n'

		readNumber = (chunk)->
			theNumber = parseFloat chunk
			if isFinite theNumber
				userinputEvent.emit userinputEventName, theNumber
			else
				userinputEvent.emit 'error'

		IN.on 'data', readNumber


# zwischennetto berechnen
class NettoAccumulator
	constructor: ->
		netto = 0

		nettoEvent = new EventEmitter()
		nettoEventName = 'netto ready'

		@wire = (handler)->
			nettoEvent.on nettoEventName, handler

		@inputNewNetto = (newNetto)->
			netto += newNetto
			nettoEvent.emit nettoEventName, netto

# neue MwSt berechnen
class MwStRechener
	constructor: (steuersatz = 0.19)->
		theSteuersatz = steuersatz

		mwstSatzEvent = new EventEmitter()
		mwstSatzEventName = 'MwStSatz ready'

		@wire = (handler)->
			mwstSatzEvent.on mwstSatzEventName, handler

		@inputNetto = (netto)->
			steuer = netto * theSteuersatz
			mwstSatzEvent.emit mwstSatzEventName, steuer

# neues brutto berechnen
class BruttoRechner
	constructor : ->
		netto = null
		mwst = null

		bruttoEvent = new EventEmitter()
		bruttoEventName = 'brutto ready'
		@wire = (handler)->
			bruttoEvent.on bruttoEventName, handler


		@inputNetto= (newnetto)->
			netto = newnetto
			process()
		@inputSteuer= (steuer)->
			mwst = steuer
			process()
		process = ()->
			if netto !=null  and mwst != null
				brutto =  netto + mwst
				netto = null
				mwst = null
				bruttoEvent.emit bruttoEventName, brutto

###Platine###
class Rechner
	constructor: ->
		#create
		nettoAccu = new NettoAccumulator()
		mwstRechner = new MwStRechener()
		bruttoRechner = new BruttoRechner()
		ui = new UI()

		#bind
		ui.wire nettoAccu.inputNewNetto
		nettoAccu.wire mwstRechner.inputNetto
		nettoAccu.wire bruttoRechner.inputNetto
		mwstRechner.wire bruttoRechner.inputSteuer
		bruttoRechner.wire ui.write

new Rechner()

console.log 'running.... quit with cmd+c'
