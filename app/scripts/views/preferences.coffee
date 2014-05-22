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

    $("body").removeClass "components-empty"

  clearComponents: ->
    component.remove(silent: true) for component in @components
    @$components.empty()
    @components = []

  onRemoveComponent: (component) =>
    component.off "remove", @onRemoveComponent
    for comp, index in @components
      @components.splice(index, 1) if comp is component

    $("body").addClass("components-empty") unless @components.length
    @checkHeight()

    _.defer -> Events.trigger "componentRemoved"

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
    return unless @$presets.val()

    Events.trigger "selectedPresetAnimation", @$presets.val()
    callback = =>
      @stopListening Events, "animationOptionsChanged"
      @stopListening Events, "componentRemoved"
      @clearPreset()

    @listenTo Events, "animationOptionsChanged", callback
    @listenTo Events, "componentRemoved", callback

    _.defer @checkHeight

  selectPreset: (preset) ->
    $preset = @$presets.find "option[data-name=\"#{preset}\"]"
    @$presets.val($preset.attr("value")).trigger "chosen:updated"

  clearPreset: =>
    @$presets.val("").trigger "chosen:updated"

module.exports = PreferencesView
