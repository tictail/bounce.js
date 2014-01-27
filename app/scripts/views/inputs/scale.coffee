BaseView = require "scripts/views/base"
glMatrix = require "gl-matrix"

template = require "templates/inputs/scale"

class ScaleInputView extends BaseView
  template: template

  getInputValue: (name) =>
   parseFloat @$("input[name=#{name}]").val()

  getTransformMatrix: (values) ->
    [x, y] = values
    z = 1
    [x, 0, 0, 0
     0, y, 0, 0
     0, 0, z, 0
     0, 0, 0, 1]

  calculateValues: (easingValues) ->
    from = ["from_x", "from_y"].map @getInputValue
    to = ["to_x", "to_y"].map @getInputValue

    diff = []
    glMatrix.vec2.sub diff, to, from

    values = []
    for easingVal in easingValues
      val = []
      glMatrix.vec2.scale val, diff, easingVal
      res = []
      glMatrix.vec2.add res, val, from
      values.push @getTransformMatrix(res)

    values.push @getTransformMatrix(to)
    values

module.exports = ScaleInputView
