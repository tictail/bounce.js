_ = require "underscore"

BaseView = require "scripts/views/base"
template = require "templates/component"

class Component extends BaseView
  template: template

  initialize: ->
    super

    @$type = @$ "#type"
    @$bounces = @$ "#bounces"
    @$shake = @$ "#shake"
    @$stiffness = @$ "#stiffness"
    @$inputs = @$ "#inputs"

    _.defer @setupInputElements

    @renderInputs()
    @$type.on "change", @renderInputs

  setupInputElements: =>
    @$type.chosen disable_search: true

  renderInputs: =>
    selected = @$type.val()

    inputViewClass = require "scripts/views/inputs/#{selected}"
    @inputView = new inputViewClass

    @$inputs.html @inputView.$el

  addToBounce: (bounce) ->
    @inputView.addToBounce bounce, {
      bounces: parseInt @$bounces.val(), 10
      shake: @$shake.prop("checked")
      stiffness: parseInt @$stiffness.val(), 10
    }

module.exports = Component