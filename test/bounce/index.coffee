Matrix4D = require "scripts/lib/bounce/math/matrix4d"
Bounce = require "bounce"

Scale = require "scripts/lib/bounce/components/scale"

describe "Bounce", ->
  bounce = null
  beforeEach ->
    bounce = new Bounce

  describe "#scale", ->
    it "adds a Scale component", ->
      bounce.scale()
      bounce.components[0].should.be.an.instanceof Scale

    it "returns itself", ->
      bounce.scale().should.equal bounce

  describe "#getKeyframes", ->
    it "returns an object with matrices", ->
      bounce.scale()
      keyframes = bounce.getKeyframes()
      keyframes.should.be.an.object
      keyframes[0].should.be.an.instanceof Matrix4D

bounce = new Bounce
