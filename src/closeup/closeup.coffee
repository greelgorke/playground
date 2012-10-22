'use strict'
slice =  Array::slice
# __public__

# _____
# __signature__:
#   _[Function,Object,Boolean] -> Function_
#      if `preserveThis` is set, `this` will be an object {co, that}, where `that` holds original `this`. Else `this` will hold co.
#
# __description__:
#   returns a function that can be passed as callback anywhere. Instead of utilize the clojure scope to access variables
#   from the parrent scope, the needed variables can be passed via this.
module.exports = closeup = (theFunc, co, preserveThis)->
  ->
    if preserveThis
      that = this
      self = {co,that}
      theFunc.apply self,  slice.call(arguments,0)
    else
      theFunc.apply co,  slice.call(arguments,0)
module.exports.displayName = 'closeup'
