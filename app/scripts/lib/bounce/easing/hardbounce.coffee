BounceEasing = require "./bounce"

class HardBounceEasing extends BounceEasing
  oscillation: (t) ->
    Math.abs Math.cos(@omega * t)

module.exports = HardBounceEasing