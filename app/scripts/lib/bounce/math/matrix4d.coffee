class Matrix4D
  _array: null
  constructor: (array) ->
    @_array = array?[..] or [
      0, 0, 0, 0
      0, 0, 0, 0
      0, 0, 0, 0
      0, 0, 0, 0
    ]

  equals: (matrix) ->
    @toString() is matrix.toString()

  identity: ->
    @setArray [
      1, 0, 0, 0
      0, 1, 0, 0
      0, 0, 1, 0
      0, 0, 0, 1
    ]
    this

  multiply: (matrix) ->
    res = new Matrix4D

    for i in [0...4]
      for j in [0...4]
        for k in [0...4]
          value = res.get(i, j) + @get(i, k) * matrix.get(k, j)
          res.set i, j, value

    @copy res

  transpose: ->
    a = @getArray()
    @setArray [
      a[0], a[4], a[8], a[12]
      a[1], a[5], a[9], a[13]
      a[2], a[6], a[10], a[14]
      a[3], a[7], a[11], a[15]
    ]
    this

  get: (row, column) ->
    @getArray()[row * 4 + column]

  set: (row, column, value) ->
    @_array[row * 4 + column] = value

  copy: (matrix) ->
    @_array = matrix.getArray()
    this

  clone: ->
    new Matrix4D @getArray()

  getArray: ->
    @_array[..]

  setArray: (array) ->
    @_array = array
    this

  toString: ->
    "(#{@getArray().join ", "})"

  toFixed: (n) ->
    @_array = (parseFloat(value.toFixed(n)) for value in @_array)
    this

module.exports = Matrix4D