_ = require "underscore"
glMatrix = require "gl-matrix"

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

    keyframes = []
    for keyframe, matrix of bounce.getKeyframes()
      transformString = "matrix3d#{matrix}"
      keyframes.push "#{keyframe}% { transform: #{transformString}; }"

    css = "@keyframes animation { \n  #{keyframes.join("\n  ")} \n}"
    Events.trigger "playAnimation",
      keyframes: css
      duration: @$duration.val()

module.exports = PreferencesView
