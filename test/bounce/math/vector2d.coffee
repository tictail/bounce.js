Vector2D = require "scripts/lib/bounce/math/vector2d"

describe "Vector2D", ->
  vector = null
  beforeEach -> vector = new Vector2D 3, 5

  describe "#toString", ->
    it "outputs in format (x, y)", ->
      vector.toString().should.equal "(3, 5)"

  describe "#add", ->
    it "adds components from the given vector", ->
      vector.add(new Vector2D(2, 5))
        .equals(new Vector2D(5, 10)).should.be.true

    it "adds scalar values", ->
      vector.add(5).equals(new Vector2D(8, 10)).should.be.true

  describe "#subtract", ->
    it "subtracts components from the given vector", ->
      vector.subtract(new Vector2D(4, -3))
        .equals(new Vector2D(-1, 8)).should.be.true

    it "subtracts scalar values", ->
      vector.subtract(3).equals(new Vector2D(0, 2)).should.be.true

  describe "#multiply", ->
    it "multiplies components from the given vector", ->
      vector.multiply(new Vector2D(2, 3))
        .equals(new Vector2D(6, 15)).should.be.true

    it "multiplies scalar values", ->
      vector.multiply(10).equals(new Vector2D(30, 50)).should.be.true

  describe "#divide", ->
    it "divides components from the given vector", ->
      vector.divide(new Vector2D(2, 3))
        .equals(new Vector2D(3 / 2, 5 / 3)).should.be.true

    it "divides scalar values", ->
      vector.divide(10).toFixed(2).equals(new Vector2D(0.3, 0.5)).should.be.true
