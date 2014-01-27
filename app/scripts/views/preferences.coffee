_ = require "underscore"
glMatrix = require "gl-matrix"

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
    valueLists = @components.map (c) -> c.calculateValues(numKeyframes)

    keyframes = []
    for i in [0..numKeyframes]
      matrix = []
      glMatrix.mat4.identity matrix

      for valueList in valueLists
        glMatrix.mat4.multiply matrix, valueList[i], matrix[..]

      glMatrix.mat4.transpose matrix, matrix[..]
      matrix = _.map matrix, (value) -> Math.round(value * 1e5) / 1e5

      transformString = "matrix3d(#{matrix.join ","})"
      keyframe = i * 100 / numKeyframes
      keyframes.push "#{keyframe}% { transform: #{transformString}; }"

    css = "@keyframes animation { \n  #{keyframes.join("\n  ")} \n}"
    Events.trigger "playAnimation",
      keyframes: css
      duration: @$duration.val()

module.exports = PreferencesView
