class Easing
  bounces: 4
  shake: false
  stiffness: 3

  constructor: (options = {}) ->
    @stiffness = options.stiffness or @stiffness
    @bounces = if options.bounces? then options.bounces else @bounces
    @shake = options.shake or @shake
    @circFunc = if @shake then Math.sin else Math.cos

    @alpha = @stiffness / 100

    threshold = 0.05 / Math.pow(10, @stiffness)
    @limit = Math.floor(Math.log(threshold) / -@alpha)
    @omega = @bounces * Math.PI / @limit

  calculate: (ratio) ->
    return 1 if ratio >= 1

    t = ratio * @limit
    1 - Math.pow(Math.E, -@alpha*t) * @circFunc(@omega*t)

module.exports = Easing