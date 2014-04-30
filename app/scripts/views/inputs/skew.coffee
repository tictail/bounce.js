_ = require "underscore"
InputView = require "./index"
template = require "templates/inputs/skew"

class SkewInputView extends InputView
  template: template

  addToBounce: (bounce, options) ->
    options = _.extend {}, options,
      from:
        x: @getInputValue "from_x"
        y: @getInputValue "from_y"

      to:
        x: @getInputValue "to_x"
        y: @getInputValue "to_y"

    bounce.skew options

module.exports = SkewInputView
