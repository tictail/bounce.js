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
  componentCounter: 0

  events:
    "click #add": "onClickAdd"
    "change .preset-input": "onChoosePreset"

  initialize: ->
    super
    @$components = @$ ".components"
    @$presets = @$ ".preset-input"
    @$separator = $ ".preference-bar-separator"
    @$container = $ ".preferences-container"

    @$presets.chosen disable_search: true
    @$presets.on "chosen:updated", @onChoosePreset

    @setHeight()
    _.defer @checkHeight
    $(window).on "resize", @setHeight
    $(window).on "resize", @checkHeight

    Events.on "preferencesHeightChanged", @checkHeight

  onClickAdd: ->
    @appendComponent()

  appendComponent: (component, options = {}) ->
    @componentCounter++
    componentView = new ComponentView
      component: component
      collapsed: options.collapsed
      number: @componentCounter

    componentView.on "remove", @onRemoveComponent

    component.close() for component in @components

    @$components.append componentView.$el
    @components.push componentView

    unless options.silent
      _.defer -> Events.trigger "componentAdded"

    $("body").removeClass "components-empty"

  clearComponents: ->
    component.remove(silent: true) for component in @components
    @$components.empty()
    @components = []
    @componentCounter = 0

  onRemoveComponent: (component) =>
    component.off "remove", @onRemoveComponent
    for comp, index in @components
      @components.splice(index, 1) if comp is component

    $("body").addClass("components-empty") unless @components.length
    @checkHeight()

    @componentCounter = 0 if @components.length is 0

    _.defer -> Events.trigger "componentRemoved"

  setHeight: =>
    offsetTop = @$components.offset().top
    windowHeight = $(window).height()

    @$components.css "max-height", windowHeight - offsetTop

  checkHeight: =>
    $body = $ "body"
    height = @$components.outerHeight() + @$components.offset().top
    height = Math.max $(window).outerHeight(), height
    height = Math.max $(".main-view").outerHeight(), height
    @$separator.height height

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
      @appendComponent component, collapsed: true, silent: true

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
