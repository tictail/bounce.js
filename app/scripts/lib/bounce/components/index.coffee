Matrix4D = require "../math/matrix4d"
Easing = require "../easing"

class Component
  from: null
  to: null

  constructor: (options) ->
    options ||= {}
    @from = options.from or @from
    @to = options.to or @to
    @easing = new Easing bounces: options.bounces, shake: options.shake

  getMatrix: ->
    new Matrix4D().identity()

  getEasedMatrix: (ratio) ->
    @getMatrix()

module.exports = Component