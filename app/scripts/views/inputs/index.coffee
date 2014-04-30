BaseView = require "scripts/views/base"

class InputView extends BaseView
  getInputValue: (name) =>
    parseFloat @$("input[name=#{name}]").val()

module.exports = InputView
