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
    "change .preset-input": "onChoosePreset"

  initialize: ->
    super
    @$components = @$ ".components"
    @$presets = @$ ".preset-input"
    @$separator = $ ".preference-bar-separator"

    @$presets.chosen disable_search: true
    @$presets.on "chosen:updated", @onChoosePreset

    @setHeight()
    $(window).on "resize", @setHeight

    @appendComponent()

    Events.on "preferencesHeightChanged", @checkHeight

  onClickAdd: ->
    @appendComponent()

  appendComponent: (component, options = {}) ->
    componentView = new ComponentView
      component: component
      collapsed: options.collapsed

    componentView.on "remove", @onRemoveComponent
    @$components.append componentView.$el
    @components.push componentView

  clearComponents: ->
    component.remove(silent: true) for component in @components
    @$components.empty()
    @components = []

  onRemoveComponent: (component) =>
    component.off "remove", @onRemoveComponent
    for comp, index in @components
      @components.splice(index, 1) if comp is component

    @appendComponent() if @components.length is 0

    _.defer ->
      Events.trigger "componentRemoved"

  setHeight: =>
    offsetTop = @$components.offset().top
    windowHeight = $(window).height()

    @$components.css "max-height", windowHeight - offsetTop

  checkHeight: =>
    $body = $ "body"
    if @$components.outerHeight() is parseInt(@$components.css("max-height"), 10)
      $body.addClass "preferences-overflown"
    else
      $body.removeClass "preferences-overflown"


  getBounceObject: =>
    bounce = new Bounce
    @components.map (c) -> c.addToBounce bounce
    bounce

  setFromBounceObject: (bounce) ->
    @clearComponents()
    for component in bounce.components
      @appendComponent component, collapsed: true

  onChoosePreset: =>
    Events.trigger "selectedPresetAnimation", @$presets.val()
    Events.off ".presetEvent"
    Events.once "animationOptionsChanged", @clearPreset
    _.defer @checkHeight

  selectPreset: (preset) ->
    $preset = @$presets.find "option[data-name=\"#{preset}\"]"
    @$presets.val($preset.attr("value")).trigger "chosen:updated"

  clearPreset: =>
    Events.off "animationOptionsChanged", @clearPreset
    @$presets.val("").trigger "chosen:updated"

module.exports = PreferencesView
