class Easing
  @ALPHA: 0.05
  @LIMIT: Math.floor(Math.log(0.0005) / -Easing.ALPHA)

  bounces: 4
  shake: false

  constructor: (options = {}) ->
    @bounces = if options.bounces? then options.bounces else @bounces
    @shake = options.shake or @shake
    @circFunc = if @shake then Math.sin else Math.cos

  calculate: (ratio) ->
    return 1 if ratio is 1

    omega = @bounces * Math.PI / Easing.LIMIT

    t = ratio * Easing.LIMIT
    1 - Math.pow(Math.E, -Easing.ALPHA*t) * @circFunc(omega*t)

module.exports = Easing