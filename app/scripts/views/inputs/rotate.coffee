_ = require "underscore"
InputView = require "./index"
template = require "templates/inputs/rotate"

class RotateInputView extends InputView
  template: template

  addToBounce: (bounce, options) ->
    options = _.extend {}, options,
      from: @getInputValue "from"
      to: @getInputValue "to"

    bounce.rotate options

module.exports = RotateInputView