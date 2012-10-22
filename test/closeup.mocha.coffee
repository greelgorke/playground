'use strict'
# __dependencies__
expect = (require 'chai').expect
closeup = require '../closeup'

# __static + private__
theClojureScope =
  foo : 'fbar'
  test: true

theThis = 'I am This'
theError = new Error()
theData = 'I am Data'

nodeCallback = (err, data)->
  expect(this.co).to.be.equal theClojureScope
  expect(this.that).to.not.exist
  expect(err).to.be.equal theError
  expect(data).to.be.equal theData

domCallback = (err, data)->
  expect(this.co).to.be.equal theClojureScope
  expect(this.that).to.be.equal theThis
  expect(err).to.be.equal theError
  expect(data).to.be.equal theData

testCaller = (callback)->
  callback theError, theData

testCallerWithThisBinding = (callback)->
  callback.call theThis, theError,theData

# __tests__
describe 'closeup', ->
  it 'should be a function, of cause', ->
    expect(closeup).to.be.a 'function'
  it 'should bind provided closureScope to this in the node-style callback', ->
    testCaller (closeup nodeCallback , theClojureScope)
  it 'should bind provided closureScope to this in the dom-style callback passing the original this binding', ->
    testCallerWithThisBinding (closeup domCallback , theClojureScope)
