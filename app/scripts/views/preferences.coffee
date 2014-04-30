_ = require "underscore"

Bounce = require "bounce"
BaseView = require "scripts/views/base"
ComponentView = require "scripts/views/component"
Events = require "scripts/events"

template = require "templates/preferences"

class PreferencesView extends BaseView
  el: "#preferences"
  template: template
  components: []

  events:
    "click #add": "onClickAdd"

  initialize: ->
    super
    @$components = @$ ".components"
    @appendComponent()

  onClickAdd: ->
    @appendComponent()

  appendComponent: (component) ->
    componentView = new ComponentView component: component
    @$components.append componentView.$el
    @components.push componentView

  clearComponents: ->
    component.remove() for component in @components
    @$components.empty()
    @components = []

  getBounceObject: =>
    bounce = new Bounce
    @components.map (c) -> c.addToBounce bounce
    bounce

  setFromBounceObject: (bounce) ->
    @clearComponents()
    for component in bounce.components
      @appendComponent component



module.exports = PreferencesView
