Matrix4D = require "scripts/lib/bounce/math/matrix4d"

describe "Matrix4D", ->
  matrix = null
  beforeEach ->
    matrix = new Matrix4D [
      1,  2,  3,  4
      5,  6,  7,  8
      9,  10, 11, 12
      13, 14, 15, 16
    ]

  describe "#constructor", ->
    it "defaults to the zero matrix", ->
      matrix = new Matrix4D()
      zeroMatrix = new Matrix4D [
        0, 0, 0, 0
        0, 0, 0, 0
        0, 0, 0, 0
        0, 0, 0, 0
      ]

      matrix.equals(zeroMatrix).should.be.true

  describe "#identity", ->
    it "converts the matrix to the identity matrix", ->
      matrix = new Matrix4D()
      matrix.identity()
      identityMatrix = new Matrix4D [
        1, 0, 0, 0
        0, 1, 0, 0
        0, 0, 1, 0
        0, 0, 0, 1
      ]

      matrix.equals(identityMatrix).should.be.true

  describe "#transpose", ->
    it "transposes the matrix", ->
      matrix.transpose()
      transposedMatrix = new Matrix4D [
        1, 5, 9, 13
        2, 6, 10, 14
        3, 7, 11, 15
        4, 8, 12, 16
      ]

      matrix.equals(transposedMatrix).should.be.true

  describe "#multiply", ->
    it "multiplies with the given matrix", ->
      matrix.multiply(matrix.clone())
      multipliedMatrix = new Matrix4D [
        90, 100, 110, 120
        202, 228, 254, 280
        314, 356, 398, 440
        426, 484, 542, 600
      ]

      matrix.equals(multipliedMatrix).should.be.true

  describe "#get", ->
    it "returns the value at the given row and column", ->
      matrix.get(1, 2).should.equal 7

  describe "#set", ->
    it "sets the value at the given row and column", ->
      matrix.set(1, 2, 100)
      modifiedMatrix = new Matrix4D [
        1, 2, 3, 4
        5, 6, 100, 8
        9, 10, 11, 12
        13, 14, 15, 16
      ]
      matrix.equals(modifiedMatrix).should.be.true

