BaseView = require "scripts/views/base"

template = require "templates/inputs/skew"

class SkewInputView extends BaseView
  template: template

  getInputValue: (name) =>
   parseFloat @$("input[name=#{name}]").val()

  getTransformString: (value) ->
    value = Math.round(value * 1e5) / 1e5
    "skew(#{value}deg)"

  calculateValues: (easingValues) ->
    from = @getInputValue "from"
    to = @getInputValue "to"
    diff = to - from

    values = []
    for easingVal in easingValues
      values.push @getTransformString(from + easingVal * diff)

    values.push @getTransformString(to)
    values

module.exports = SkewInputView