HardBounceEasing = require "scripts/lib/bounce/easing/hardbounce"
helpers = require "../helpers"

describe "HardBounceEasing", ->
  easing = null
  beforeEach -> easing = new HardBounceEasing

  describe "#calculate", ->
    it "calculates an eased ratio", ->
      easing.calculate(0.5).should.be.a.number

    it "bounces the given number of times", ->
      easing = new HardBounceEasing bounces: 4

      # numBounces calculates the number of times the easing changes
      # direction, but it makes more sense here to count the number
      # of bounces against the "wall", so we multiply the result with 2
      helpers.numBounces(easing).should.equal 4 * 2

      easing = new HardBounceEasing bounces: 10
      helpers.numBounces(easing).should.equal 10 * 2

    it "starts at 0", ->
      easing = new HardBounceEasing
      easing.calculate(0).should.equal 0

    it "ends at 1", ->
      easing.calculate(1).should.equal 1
