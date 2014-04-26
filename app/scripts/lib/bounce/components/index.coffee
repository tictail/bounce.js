Matrix4D = require "../math/matrix4d"
Easing = require "../easing"

class Component
  duration: 1000
  delay: 0
  from: null
  to: null

  constructor: (options) ->
    options ||= {}
    @duration = if options.duration? then options.duration else @duration
    @delay = if options.delay? then options.delay else @delay
    @from = if options.from? then options.from else @from
    @to = if options.to? then options.to else @to
    @easing = new Easing options

  getMatrix: ->
    new Matrix4D().identity()

  getEasedMatrix: (ratio) ->
    @getMatrix()

module.exports = Component