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
    "click #add": "appendComponent"

  initialize: ->
    super
    @appendComponent()

  appendComponent: =>
    component = new ComponentView
    @$el.append component.$el
    @components.push component

  getBounceObject: =>
    bounce = new Bounce
    @components.map (c) -> c.addToBounce bounce
    bounce

module.exports = PreferencesView
