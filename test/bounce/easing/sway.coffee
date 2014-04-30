SwayEasing = require "scripts/lib/bounce/easing/sway"
helpers = require "../helpers"

describe "SwayEasing", ->
  easing = null
  beforeEach -> easing = new SwayEasing

  describe "#calculate", ->
    it "calculates an eased ratio", ->
      easing.calculate(0.5).should.be.a.number

    it "bounces the given number of times", ->
      easing = new SwayEasing bounces: 4
      helpers.numBounces(easing).should.equal 4

      easing = new SwayEasing bounces: 10
      helpers.numBounces(easing).should.equal 10

    it "starts at 0", ->
      easing = new SwayEasing
      easing.calculate(0).should.equal 0

    it "ends at 0", ->
      easing.calculate(1).should.equal 0
