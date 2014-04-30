_ = require "underscore"
InputView = require "./index"
template = require "templates/inputs/rotate"

class RotateInputView extends InputView
  type: "rotate"
  template: template

module.exports = RotateInputView