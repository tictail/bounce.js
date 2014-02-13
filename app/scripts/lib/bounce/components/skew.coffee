Matrix4D = require "../math/matrix4d"
Vector2D = require "../math/vector2d"

Easing = require "../easing"
Component = require "./index"

class Skew extends Component
  from: 0
  to: 10

  constructor: ->
    super
    @diff = @to - @from

  getMatrix: (degrees) ->
    radians = (degrees / 180) * Math.PI
    t = Math.tan radians
    new Matrix4D [
      1, t, 0, 0
      0, 1, 0, 0
      0, 0, 1, 0
      0, 0, 0, 1
    ]

  getEasedMatrix: (ratio) ->
    easedRatio = @easing.calculate ratio
    easedAngle = @from + @diff * easedRatio
    @getMatrix easedAngle

module.exports =Skew