Matrix4D = require "../math/matrix4d"
EasingObjects =
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

    @easingObject = new EasingObjects[@easing] options

  calculateEase: (ratio) ->
    @easingObject.calculate ratio

  getMatrix: ->
    new Matrix4D().identity()

  getEasedMatrix: (ratio) ->
    @getMatrix()

module.exports = Component