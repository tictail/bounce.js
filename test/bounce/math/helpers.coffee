MathHelpers = require "scripts/lib/bounce/math/helpers"

describe "MathHelpers", ->
  describe "#findTurningPoints", ->
    it "finds a set of turning points given a list of values", ->
      values = (Math.pow(x - 2, 2) for x in [0..5])
      MathHelpers.findTurningPoints(values).should.deep.equal [2]

  describe "#areaBetweenLineAndCurve", ->
    it "calculate the area between a given line and curve", ->
      values = (Math.pow(x, 2) for x in [0..5])
      answer = (3 - 1) + (6 - 4)
      MathHelpers.areaBetweenLineAndCurve(values, 0, 3).should.equal answer
