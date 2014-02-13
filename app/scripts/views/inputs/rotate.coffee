BaseView = require "scripts/views/base"

template = require "templates/inputs/rotate"

class RotateInputView extends BaseView
  template: template

  getInputValue: (name) =>
   parseFloat @$("input[name=#{name}]").val()

  addToBounce: (bounce, options) ->
    bounce.rotate
      bounces: options.bounces
      shake: options.shake
      from: @getInputValue "from"
      to: @getInputValue "to"

module.exports = RotateInputView