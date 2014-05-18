_ = require "underscore"

Events = require "scripts/events"
BaseView = require "scripts/views/base"
template = require "templates/component"

class Component extends BaseView
  template: template
  className: "component"

  events:
    "change .type-input": "renderInputs"
    "change select, stiffness-input": "onInputChanged"
    "click .header": "toggleOpen"

  isOpen: true

  initialize: (options = {}) ->
    super

    @$header = @$ ".header"
    @$type = @$ ".type-input"
    @$easing = @$ ".easing-input"
    @$bounces = @$ ".bounces-input"
    @$duration = @$ ".duration-input"
    @$delay = @$ ".delay-input"
    @$stiffness = @$ ".stiffness-input"
    @$inputs = @$ ".inputs"

    if options.component
      @setValues(options.component)
    else
      @renderInputs()

    _.defer @setupInputElements

  setValues: (component) ->
    serialized = component.serialize()

    for input in ["type", "easing", "bounces", "duration", "delay", "stiffness"]
      @["$#{input}"].val(serialized[input]).data("val", serialized[input])

    @renderInputs()
    @inputView.setValues component

  setupInputElements: =>
    @$type.chosen disable_search: true
    @$easing.chosen disable_search: true

    @$stiffness.noUiSlider(
      start: @$stiffness.data("val") or 3
      step: 1
      range:
        min: 1
        max: 5
      serialization:
        lower: [
          $.Link(
            target: @$ ".stiffness-value"
            format:
              decimals: 0
          )
        ]

    )

  renderInputs: =>
    selected = @$type.val()

    inputViewClass = require "scripts/views/inputs/#{selected}"
    @inputView = new inputViewClass

    @$inputs.html @inputView.$el

    @$("input")
      .off ".animationInputChange"
      .on "keydown.animationInputChange", (e) =>
        _.defer @onDebouncedInputChanged, $(e.target)

    @$header.find(".name").text \
      @$type.find("option[value=\"#{@$type.val()}\"]").text()

    @$("input").each ->
      $this = $ this
      $this.data("prev-val", $this.val())

  toggleOpen: ->
    if @isOpen
      @$el.addClass("closed").removeClass "open"
    else
      @$el.addClass("open").removeClass "closed"

    @isOpen = !@isOpen

  addToBounce: (bounce) ->
    @inputView.addToBounce bounce, {
      easing: @$easing.val()
      duration: parseInt @$duration.val(), 10
      delay: parseInt @$delay.val(), 10
      bounces: parseInt @$bounces.val(), 10
      stiffness: parseInt @$stiffness.val(), 10
    }

  remove: ->
    @$type.off "change"
    @$("input").off ".animationInputChange"
    @$("select, .stiffness-input").off "change"

  onDebouncedInputChanged: ($target) =>
    return if $target.data("prev-val") is $target.val()
    $target.data("prev-val", $target.val())

    unless @debouncedInputChanged
      @debouncedInputChanged = _.debounce @onInputChanged, 150

    @debouncedInputChanged()

  onInputChanged: ->
    Events.trigger "animationOptionsChanged"

module.exports = Component