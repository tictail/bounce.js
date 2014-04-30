BounceEasing = require "scripts/lib/bounce/easing/bounce"
helpers = require "../helpers"

describe "BounceEasing", ->
  easing = null
  beforeEach -> easing = new BounceEasing

  describe "#calculate", ->
    it "calculates an eased ratio", ->
      easing.calculate(0.5).should.be.a.number

    it "bounces the given number of times", ->
      easing = new BounceEasing bounces: 4
      helpers.numBounces(easing).should.equal 4

      easing = new BounceEasing bounces: 10
      helpers.numBounces(easing).should.equal 10

    it "starts at 0", ->
      easing = new BounceEasing
      easing.calculate(0).should.equal 0

    it "ends at 1", ->
      easing.calculate(1).should.equal 1
