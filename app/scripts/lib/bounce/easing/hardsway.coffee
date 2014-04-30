SwayEasing = require "./sway"

class HardSwayEasing extends SwayEasing
  oscillation: (t) ->
    Math.abs Math.sin(@omega * t)

module.exports = HardSwayEasing