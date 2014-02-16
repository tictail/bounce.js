Matrix4D = require "../math/matrix4d"
Easing = require "../easing"

class Component
  from: null
  to: null

  constructor: (options) ->
    options ||= {}
    @from = if options.from? then options.from else @from
    @to = if options.to? then options.to else @to
    @easing = new Easing options

  getMatrix: ->
    new Matrix4D().identity()

  getEasedMatrix: (ratio) ->
    @getMatrix()

module.exports = Component