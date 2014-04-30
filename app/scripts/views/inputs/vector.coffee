_ = require "underscore"
InputView = require "./index"

class VectorInputView extends InputView
  addToBounce: (bounce, options) ->
    options = _.extend {}, options,
      from:
        x: @getInputValue "from_x"
        y: @getInputValue "from_y"
      to:
        x: @getInputValue "to_x"
        y: @getInputValue "to_y"

    bounce[@type] options

  setValues: (component) ->
    @setInputValue "from_x", component.from.x
    @setInputValue "from_y", component.from.y

    @setInputValue "to_x", component.to.x
    @setInputValue "to_y", component.to.y

module.exports = VectorInputView