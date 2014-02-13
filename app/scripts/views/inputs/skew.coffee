BaseView = require "scripts/views/base"

template = require "templates/inputs/skew"

class SkewInputView extends BaseView
  template: template

  getInputValue: (name) =>
   parseFloat @$("input[name=#{name}]").val()

  addToBounce: (bounce, options) ->
    bounce.skew
      bounces: options.bounces
      shake: options.shake
      from: @getInputValue "from"
      to: @getInputValue "to"

module.exports = SkewInputView
