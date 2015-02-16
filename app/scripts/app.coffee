require "scripts/setup"

_ = require "underscore"
PrefixFree = require "prefixfree"
Bounce = require "bounce"

Events = require "scripts/events"
BaseView = require "scripts/views/base"
PreferencesView = require "scripts/views/preferences"
BoxView = require "scripts/views/box"
ExportView = require "scripts/views/export"
ShortenView = require "scripts/views/shorten"
Events = require "scripts/events"
URLHandler = require "scripts/urlhandler"

template = require "templates/app"

class App extends BaseView
  el: ".app"
  template: template

  events:
    "click .spin-link": "animateSpin"
    "click .play-button": "onClickPlay"
    "click .shorten-link": "onClickShorten"
    "click .export-link": "onClickExport"
    "mousedown .box": "startBoxDrag"
    "toggle .loop-input, .slow-input": "playAnimation"

  initialize: ->
    super

    $("body").addClass "unsupported" unless Bounce.isSupported()

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
    @shortenView = new ShortenView

    @$loop = @$(".actions .loop-input").toggleButton()
    @$slow = @$(".actions .slow-input").toggleButton()

    Events.on
      "animationOptionsChanged": @playAnimation
      "selectedPresetAnimation": @onSelectPreset
      "componentRemoved": @playAnimation
      "componentAdded": @playAnimation

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
      $body.removeClass("play-empty")
      _.defer =>
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

  onClickShorten: (e) ->
    e.preventDefault()
    bounce = @preferences.getBounceObject()
    if bounce.components.length
      req = URLHandler.shorten @encodeURL(bounce)
      @shortenView.show().setShortenRequest req
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
    #{bounce.getKeyframeCSS(name: "animation", optimized: true)}
    """

    @$style.text PrefixFree.prefixCSS(css, true)

    @$box.removeClass "animate"
    @$box[0].offsetWidth
    @$box.addClass "animate"

    @updateURL(bounce) unless options.updateURL is false

  animateSpin: (e) ->
    e.preventDefault()
    @preferences.selectPreset "spin"

  encodeURL: (bounce) ->
    URLHandler.encodeURL bounce.serialize(), loop: @$loop.toggleButton("isOn")

  updateURL: (bounce) ->
    window.location.hash = @encodeURL bounce

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
      options = URLHandler.decodeURL str
      bounce.deserialize options.serialized
    catch e
      return

    @$loop.toggleButton (if options.loop then "on" else "off"), silent: true

    @playAnimation bounceObject: bounce, updateURL: false
    @preferences.setFromBounceObject bounce

module.exports = App