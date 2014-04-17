_ = require "underscore"

BaseView = require "scripts/views/base"

template = require "templates/inputs/skew"

class SkewInputView extends BaseView
  template: template

  getInputValue: (name) =>
   parseFloat @$("input[name=#{name}]").val()

  addToBounce: (bounce, options) ->
    options = _.extend {}, options,
      from: @getInputValue "from"
      to: @getInputValue "to"

    bounce.skew options

module.exports = SkewInputView
