_ = require "underscore"

Events = require "scripts/events"
BaseView = require "scripts/views/base"
template = require "templates/component"

class Component extends BaseView
  template: template
  className: "component"

  events:
    "change .type-input": "renderInputs"
    "change select, .stiffness-input": "onInputChanged"
    "click .header": "toggleOpen"
    "click .remove": "onClickRemove"

  isOpen: false

  initialize: (options = {}) ->
    super

    @number = options.number

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

    unless options.collapsed
      _.defer => @toggleOpen()

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

    @$header.find(".name").html """
         #{@$type.find("option[value=\"#{@$type.val()}\"]").text()}
      <span class=\"num\">##{@number}</span>
    """

    @$("input").each ->
      $this = $ this
      $this.data("prev-val", $this.val())

  toggleOpen: ->
    if @isOpen
      @close()
    else
      @open()

  open: ->
    return if @isOpen
    @$el.addClass("open").removeClass "closed"
    @isOpen = true
    setTimeout (-> Events.trigger "preferencesHeightChanged"), 300

  close: ->
    return unless @isOpen
    @$el.addClass("closed").removeClass "open"
    @isOpen = false
    setTimeout (-> Events.trigger "preferencesHeightChanged"), 300

  onClickRemove: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @remove()

  remove: (options = {}) ->
    @$el.remove()
    @trigger("remove", this) unless options.silent

  addToBounce: (bounce) ->
    @inputView.addToBounce bounce, {
      easing: @$easing.val()
      duration: parseInt @$duration.val(), 10
      delay: parseInt @$delay.val(), 10
      bounces: parseInt @$bounces.val(), 10
      stiffness: parseInt @$stiffness.val(), 10
    }

  onDebouncedInputChanged: ($target) =>
    return if $target.data("prev-val") is $target.val()
    $target.data("prev-val", $target.val())

    unless @debouncedInputChanged
      @debouncedInputChanged = _.debounce @onInputChanged, 150

    @debouncedInputChanged()

  onInputChanged: ->
    Events.trigger "animationOptionsChanged"

module.exports = Component