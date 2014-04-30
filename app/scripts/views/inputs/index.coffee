_ = require "underscore"
BaseView = require "scripts/views/base"

class InputView extends BaseView
  getInputValue: (name) =>
    parseFloat @$("input[name=#{name}]").val()

  setInputValue: (name, value) ->
    @$("input[name=#{name}]").val(value)

  setValues: (component) ->
    @setInputValue "from", component.from
    @setInputValue "to", component.to

  addToBounce: (bounce, options) ->
    options = _.extend {}, options,
      from: @getInputValue "from"
      to: @getInputValue "to"

    bounce[@type] options

module.exports = InputView
