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
    "click #play": "playAnimation"

  initialize: ->
    super
    @appendComponent()
    @$duration = @$ "#duration"

  appendComponent: =>
    component = new ComponentView
    @$el.append component.$el
    @components.push component

  playAnimation: =>
    numKeyframes = 25
    bounce = new Bounce
    @components.map (c) -> c.addToBounce bounce

    Events.trigger "playAnimation",
      bounce: bounce
      duration: @$duration.val()

module.exports = PreferencesView
