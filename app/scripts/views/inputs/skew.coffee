VectorInputView = require "./vector"
template = require "templates/inputs/skew"

class SkewInputView extends VectorInputView
  template: template
  type: "skew"

module.exports = SkewInputView
