BounceEasing = require "./bounce"

class SwayEasing extends BounceEasing
  calculate: (ratio) ->
    return 0 if ratio >= 1

    t = ratio * @limit
    @exponent(t) * @oscillation(t)

  calculateOmega: (bounces, limit) ->
    @bounces * Math.PI / @limit

  oscillation: (t) ->
    Math.sin @omega * t

module.exports = SwayEasing