BaseView = require "scripts/views/base"

template = require "templates/inputs/rotate"

class RotateInputView extends BaseView
  template: template

  getInputValue: (name) =>
   parseFloat @$("input[name=#{name}]").val()

  getTransformMatrix: (value) ->
    radians = (value / 180) * Math.PI
    c = Math.cos radians
    s = Math.sin radians
    [c, -s, 0, 0
     s,  c, 0, 0
     0,  0, 1, 0
     0,  0, 0, 1]

  calculateValues: (easingValues) ->
    from = @getInputValue "from"
    to = @getInputValue "to"
    diff = to - from

    values = []
    for easingVal in easingValues
      values.push @getTransformMatrix(from + easingVal * diff)

    values.push @getTransformMatrix(to)
    values

module.exports = RotateInputView