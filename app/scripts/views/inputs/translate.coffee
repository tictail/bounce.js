VectorInputView = require "./vector"
template = require "templates/inputs/translate"

class TranslateInputView extends VectorInputView
  template: template
  type: "translate"

module.exports = TranslateInputView
