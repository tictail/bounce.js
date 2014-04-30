Matrix4D = require "../math/matrix4d"
Vector2D = require "../math/vector2d"

Component = require "./index"

class Rotate extends Component
  from: 0
  to: 90

  constructor: ->
    super
    @diff = @to - @from

  getMatrix: (degrees) ->
    radians = (degrees / 180) * Math.PI
    c = Math.cos radians
    s = Math.sin radians
    new Matrix4D [
      c, -s, 0, 0
      s,  c, 0, 0
      0,  0, 1, 0
      0,  0, 0, 1
    ]

  getEasedMatrix: (ratio) ->
    easedRatio = @calculateEase ratio
    easedAngle = @from + @diff * easedRatio
    @getMatrix easedAngle

module.exports = Rotate