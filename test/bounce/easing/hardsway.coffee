HardSwayEasing = require "scripts/lib/bounce/easing/hardsway"
helpers = require "../helpers"

describe "HardSwayEasing", ->
  easing = null
  beforeEach -> easing = new HardSwayEasing

  describe "#calculate", ->
    it "calculates an eased ratio", ->
      easing.calculate(0.5).should.be.a.number

    it "bounces the given number of times", ->
      easing = new HardSwayEasing bounces: 4

      # numBounces calculates the number of times the easing changes
      # direction, but it makes more sense here to count the number
      # of bounces against the "wall", so we multiply the result with 2.
      # The hard sway also has one less bounce.
      helpers.numBounces(easing).should.equal 4 * 2 - 1

      easing = new HardSwayEasing bounces: 10
      helpers.numBounces(easing).should.equal 10 * 2 - 1

    it "starts at 0", ->
      easing = new HardSwayEasing
      easing.calculate(0).should.equal 0

    it "ends at 0", ->
      easing.calculate(1).should.equal 0
