_ = require "underscore"

BaseView = require "scripts/views/base"

template = require "templates/inputs/rotate"

class RotateInputView extends BaseView
  template: template

  getInputValue: (name) =>
   parseFloat @$("input[name=#{name}]").val()

  addToBounce: (bounce, options) ->
    options = _.extend {}, options,
      from: @getInputValue "from"
      to: @getInputValue "to"

    bounce.rotate options

module.exports = RotateInputView