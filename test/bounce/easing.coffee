Easing = require "scripts/lib/bounce/easing"
describe "Easing", ->
  easing = null
  beforeEach -> easing = new Easing

  describe "#constructor", ->
    it "sets the circular function to Math.cos if shake is false", ->
      easing = new Easing shake: false
      easing.circFunc.should.equal Math.cos

    it "set the circular function to Math.sin if shake is true", ->
      easing = new Easing shake: true
      easing.circFunc.should.equal Math.sin

  describe "#calculate", ->
    sign = (value) -> if value < 0 then -1 else 1
    calculateBounces = (easing) ->
      bounces = 0
      values = []

      for i in [0..1] by 0.001
        values.push easing.calculate(i)
        len = values.length

        signA = sign(values[len - 2] - values[len - 3])
        signB = sign(values[len - 1] - values[len - 2])
        if signA isnt signB
          bounces++

      bounces

    it "calculates an eased ratio", ->
      easing.calculate(0.5).should.be.a.number

    it "bounces the given number of times", ->
      easing = new Easing bounces: 4
      calculateBounces(easing).should.equal 4

      easing = new Easing bounces: 10
      calculateBounces(easing).should.equal 10

    it "starts at 0 when shake is false", ->
      easing = new Easing shake: false
      easing.calculate(0).should.equal 0

    it "starts at 1 when shake is true", ->
      easing = new Easing shake: true
      easing.calculate(0).should.equal 1

    it "ends at 1", ->
      easing.calculate(1).should.equal 1








