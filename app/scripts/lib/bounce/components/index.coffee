Matrix4D = require "../math/matrix4d"
EasingClasses =
  bounce: require "../easing/bounce"
  sway: require "../easing/sway"
  hardbounce: require "../easing/hardbounce"
  hardsway: require "../easing/hardsway"

class Component
  easing: "bounce"
  duration: 1000
  delay: 0
  from: null
  to: null

  constructor: (options) ->
    options ||= {}
    @easing = options.easing if options.easing?
    @duration = options.duration if options.duration?
    @delay = options.delay if options.delay?
    @from = options.from if options.from?
    @to = options.to if options.to?

    @easingObject = new EasingClasses[@easing] options

  calculateEase: (ratio) ->
    @easingObject.calculate ratio

  getMatrix: ->
    new Matrix4D().identity()

  getEasedMatrix: (ratio) ->
    @getMatrix()

  serialize: ->
    serialized =
      type: @constructor.name.toLowerCase()
      easing: @easing
      duration: @duration
      delay: @delay
      from: @from
      to: @to

    for key, value of @easingObject.serialize()
      serialized[key] = value

    serialized

module.exports = Component