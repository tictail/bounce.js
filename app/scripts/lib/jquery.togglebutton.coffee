$ = require "jquery"

class ToggleButton
  _isOn: false

  constructor: (@el, options = {}) ->
    @$el = $ @el
    @on() if options.on

    @$el.on "click", @toggle

  toggle: =>
    if @_isOn then @off() else @on()

  on: (options = {}) ->
    @_isOn = true
    @$el.addClass "on"

    unless options.silent
      @$el
        .trigger "toggle"
        .trigger "toggleOn"

  off: (options = {}) ->
    @_isOn = false
    @$el.removeClass "on"

    unless options.silent
      @$el
        .trigger "toggle"
        .trigger "toggleOff"

  isOn: ->
    @_isOn

$.fn.toggleButton = (method, options) ->
  returnValue = undefined
  @each ->
    toggleButton = $.data this, "plugin_toggleButton"
    if toggleButton
      return unless typeof method is "string"
      returnValue = toggleButton[method] options
      return
    else
      $.data this, "plugin_toggleButton", new ToggleButton(this, method)

  if returnValue? then returnValue else this