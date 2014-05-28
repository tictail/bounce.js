require "scripts/setup"

_ = require "underscore"
PrefixFree = require "prefixfree"
Bounce = require "bounce"

Events = require "scripts/events"
BaseView = require "scripts/views/base"
PreferencesView = require "scripts/views/preferences"
BoxView = require "scripts/views/box"
ExportView = require "scripts/views/export"
Events = require "scripts/events"

template = require "templates/app"

class App extends BaseView
  el: ".app"
  template: template

  events:
    "click .spin-link": "animateSpin"
    "click .play-button": "onClickPlay"
    "click .export-link": "onClickExport"
    "mousedown .box": "startBoxDrag"
    "toggle .loop-input, .slow-input": "playAnimation"

  initialize: ->
    super

    @$style = @$ "#animation"
    @$result = @$ "#result"
    @$box = @$result.find ".box"
    @$main = @$ ".main-view"

    @centerView()
    $(window).on "resize", @centerView

    @playIntro()

    @preferences = new PreferencesView
    @boxView = new BoxView
    @exportView = new ExportView


    @$loop = @$(".actions .loop-input").toggleButton()
    @$slow = @$(".actions .slow-input").toggleButton()

    Events.on
      "animationOptionsChanged": @playAnimation
      "selectedPresetAnimation": @onSelectPreset
      "componentRemoved": @playAnimation

    @readURL()

  playIntro: ->
    return unless window.location.hash is "" and not localStorage["seenIntro"]
    $body = $ "body"
    $body.addClass "play-intro"
    setTimeout ->
      localStorage["seenIntro"] = true
      $body.removeClass "play-intro"
    , 5000

  centerView: =>
    padding = Math.floor(($(window).outerHeight() - @$main.outerHeight()) / 2 - 45)
    @$main.css "padding-top", Math.max(padding, 60)

  onClickPlay: ->
    if @preferences.getBounceObject().components.length
      @playAnimation()
    else
      @onPlayEmpty()

  onPlayEmpty: ->
      $body = $ "body"
      $body.addClass "play-empty"
      clearTimeout(@playEmptyTimeout) if @playEmptyTimeout
      @playEmptyTimeout = setTimeout (-> $body.removeClass "play-empty"), 1000

  onClickExport: (e) ->
    e.preventDefault()

    bounce = @preferences.getBounceObject()
    if bounce.components.length
      @exportView.setBounceObject @preferences.getBounceObject()
      @exportView.show()
    else
      @onPlayEmpty()

  playAnimation: (options = {}) =>
    bounce = options.bounceObject or @preferences.getBounceObject()
    unless bounce.components.length
      window.location.hash = ""
      @$box.removeClass "animate"
      return

    duration = options.duration or bounce.duration
    duration *= 10 if @$slow.toggleButton("isOn") and not options.duration

    properties = []
    properties.push "animation-duration: #{duration}ms"

    if @$loop.toggleButton("isOn")
      properties.push("animation-iteration-count: infinite")

    css = """
    .box.animate {
      #{properties.join(";\n  ")};
    }
    #{bounce.getKeyframeCSS(name: "animation")}
    """

    @$style.text PrefixFree.prefixCSS(css, true)

    @$box.removeClass "animate"
    @$box[0].offsetWidth
    @$box.addClass "animate"

    @updateURL(bounce) unless options.updateURL is false

  animateSpin: (e) ->
    e.preventDefault()
    @preferences.selectPreset "spin"

  updateURL: (bounce) ->
    window.location.hash = @_encodeURL bounce.serialize()

  readURL: ->
    return unless window.location.hash
    @deserializeBounce window.location.hash[1..]

  onSelectPreset: (preset) =>
    window.location.hash = preset if preset
    @readURL()

  deserializeBounce: (str) =>
    return unless str
    bounce = new Bounce
    options = null
    try
      options = @_decodeURL(str)
      bounce.deserialize options.serialized
    catch e
      return

    @$loop.toggleButton (if options.loop then "on" else "off"), silent: true

    @playAnimation bounceObject: bounce, updateURL: false
    @preferences.setFromBounceObject bounce

  @_shortKeys:
    "type": "T"
    "easing": "e"
    "duration": "d"
    "delay": "D"
    "from": "f"
    "to": "t"
    "bounces": "b"
    "stiffness": "s"

  @_shortValues:
    "bounce": "b"
    "sway": "s"
    "hardbounce": "B"
    "hardsway": "S"
    "scale": "c"
    "skew": "k"
    "translate": "t"
    "rotate": "r"

  @_longKeys: _.invert App._shortKeys
  @_longValues: _.invert App._shortValues

  _encodeURL: (serialized) ->
    encoded = {}
    encoded.l = 1 if @$loop.toggleButton("isOn")
    encoded.s = for options in serialized
      shortKeys = {}
      for key, value of options
        shortKeys[App._shortKeys[key] or key] =
          App._shortValues[value] or value

      shortKeys

    stringified = JSON.stringify(encoded)
    # Remove double quotes in properties
    stringified.replace(/(\{|,)"([a-z0-9]+)"(:)/gi, "$1$2$3")


  _decodeURL: (str) ->
    # Add back the double quotes in properties
    json = str.replace(/(\{|,)([a-z0-9]+)(:)/gi, "$1\"$2\"$3")
    decoded = JSON.parse(json)
    unshortened = for options in decoded.s
      longKeys = {}
      for key, value of options
        longKeys[App._longKeys[key] or key] =
          App._longValues[value] or value

      longKeys

    {
      serialized: unshortened
      loop: decoded.l
    }

module.exports = App