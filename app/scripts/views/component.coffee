BaseView = require "scripts/views/base"
template = require "templates/component"

class Component extends BaseView
  template: template
  initialize: ->
    super

    @$type = @$ "#type"
    @$bounces = @$ "#bounces"
    @$shake = @$ "#shake"
    @$inputs = @$ "#inputs"

    @renderInputs()
    @$type.on "change", @renderInputs

  renderInputs: =>
    selected = @$type.val()

    inputViewClass = require "scripts/views/inputs/#{selected}"
    @inputView = new inputViewClass

    @$inputs.html @inputView.$el

  addToBounce: (bounce) ->
    @inputView.addToBounce bounce, {
      bounces: parseInt @$bounces.val(), 10
      shake: @$shake.prop("checked")
    }

module.exports = Component