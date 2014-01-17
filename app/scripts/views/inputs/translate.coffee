BaseView = require "scripts/views/base"
glMatrix = require "gl-matrix"

template = require "templates/inputs/translate"

class TranslateInputView extends BaseView
  template: template

  getInputValue: (name) =>
   parseFloat @$("input[name=#{name}]").val()

  getTransformString: (value) ->
    value = value.map (n) -> Math.round(n * 1e5) / 1e5
    "translate(#{value.join "px ,"}px)"

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
      values.push @getTransformString(res)

    values.push @getTransformString(to)
    values

module.exports = TranslateInputView
