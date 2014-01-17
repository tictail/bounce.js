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
    numKeyframes = 100
    valueLists = @components.map (c) -> c.calculateValues(numKeyframes)

    keyframes = []
    for i in [0..numKeyframes]
      transforms = []
      for valueList in valueLists
        transforms.push valueList[i]

      transformString = transforms.join " "
      keyframe = i * 100 / numKeyframes
      keyframes.push "#{keyframe}% { transform: #{transformString}; }"

    css = "@keyframes animation { \n  #{keyframes.join("\n  ")} \n}"
    Events.trigger "playAnimation",
      keyframes: css
      duration: @$duration.val()

module.exports = PreferencesView
