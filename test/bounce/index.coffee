Matrix4D = require "scripts/lib/bounce/math/matrix4d"
Bounce = require "bounce"

Scale = require "scripts/lib/bounce/components/scale"
Translate = require "scripts/lib/bounce/components/translate"
Skew = require "scripts/lib/bounce/components/skew"
Rotate = require "scripts/lib/bounce/components/rotate"

describe "Bounce", ->
  bounce = null
  beforeEach ->
    bounce = new Bounce

  describe "#scale", ->
    it "adds a Scale component", ->
      bounce.scale()
      bounce.components[0].should.be.an.instanceof Scale

  describe "#translate", ->
    it "adds a Translate component", ->
      bounce.translate()
      bounce.components[0].should.be.an.instanceof Translate

  describe "#skew", ->
    it "adds a Skew component", ->
      bounce.skew()
      bounce.components[0].should.be.an.instanceof Skew

  describe "#rotate", ->
    it "adds a Rotate component", ->
      bounce.rotate()
      bounce.components[0].should.be.an.instanceof Rotate

  describe "#serialize", ->
    it "serializes into JSON", ->
      bounce.scale().translate()
      serialized = bounce.serialize()

      serialized.length.should.equal 2
      serialized[0].type.should.equal "scale"
      serialized[1].type.should.equal "translate"

  describe "#deserialize", ->
    it "builds a Bounce object from the given JSON", ->
      bounce.scale().translate()
      deserialized = (new Bounce()).deserialize bounce.serialize()
      deserialized.components[0].should.be.an.instanceof Scale
      deserialized.components[1].should.be.an.instanceof Translate

  describe "#getKeyframes", ->
    it "returns an object with matrices", ->
      bounce.scale()
      keyframes = bounce.getKeyframes()
      keyframes.should.be.an.object
      keyframes[0].should.be.an.instanceof Matrix4D

