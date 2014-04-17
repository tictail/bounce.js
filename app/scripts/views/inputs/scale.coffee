_ = require "underscore"
BaseView = require "scripts/views/base"
glMatrix = require "gl-matrix"

template = require "templates/inputs/scale"

class ScaleInputView extends BaseView
  template: template

  getInputValue: (name) =>
   parseFloat @$("input[name=#{name}]").val()

  addToBounce: (bounce, options) ->
    options = _.extend {}, options,
      from:
        x: @getInputValue "from_x"
        y: @getInputValue "from_y"
      to:
        x: @getInputValue "to_x"
        y: @getInputValue "to_y"

    bounce.scale options

module.exports = ScaleInputView
