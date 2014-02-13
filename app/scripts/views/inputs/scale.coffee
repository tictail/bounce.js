BaseView = require "scripts/views/base"
glMatrix = require "gl-matrix"

template = require "templates/inputs/scale"

class ScaleInputView extends BaseView
  template: template

  getInputValue: (name) =>
   parseFloat @$("input[name=#{name}]").val()

  addToBounce: (bounce, options) ->
    bounce.scale
      bounces: options.bounces
      shake: options.shake
      from:
        x: @getInputValue "from_x"
        y: @getInputValue "from_y"
      to:
        x: @getInputValue "to_x"
        y: @getInputValue "to_y"

module.exports = ScaleInputView
