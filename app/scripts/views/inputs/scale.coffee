VectorInputView = require "./vector"
template = require "templates/inputs/scale"

class ScaleInputView extends VectorInputView
  template: template
  type: "scale"

module.exports = ScaleInputView
