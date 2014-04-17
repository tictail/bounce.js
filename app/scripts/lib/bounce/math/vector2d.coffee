class Vector2D
  x: 0
  y: 0

  constructor: (@x = 0, @y = 0) ->

  add: (vector) ->
    return @_addScalar(vector) unless Vector2D.isVector2D vector
    @x += vector.x
    @y += vector.y
    this

  _addScalar: (n) ->
    @x += n
    @y += n
    this

  subtract: (vector) ->
    return @_subtractScalar(vector) unless Vector2D.isVector2D vector
    @x -= vector.x
    @y -= vector.y
    this

  _subtractScalar: (n) ->
    @_addScalar -n

  multiply: (vector) ->
    return @_multiplyScalar(vector) unless Vector2D.isVector2D vector
    @x *= vector.x
    @y *= vector.y
    this

  _multiplyScalar: (n) ->
    @x *= n
    @y *= n
    this

  divide: (vector) ->
    return @_divideScalar(vector) unless Vector2D.isVector2D vector
    @x /= vector.x
    @y /= vector.y
    this

  _divideScalar: (n) ->
    @_multiplyScalar(1 / n)

  clone: ->
    new Vector2D @x, @y

  copy: (vector) ->
    @x = vector.x
    @y = vector.y
    this

  equals: (vector) ->
    vector.x is @x and vector.y is @y

  toString: ->
    "(#{@x}, #{@y})"

  toFixed: (n) ->
    @x = parseFloat @x.toFixed(n)
    @y = parseFloat @y.toFixed(n)
    this

  toArray: ->
    [@x, @y]

  @isVector2D: (item) ->
    item instanceof Vector2D

module.exports = Vector2D