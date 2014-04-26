require "scripts/setup"

_ = require "underscore"
PrefixFree = require "prefixfree"
Bounce = require "bounce"

BaseView = require "scripts/views/base"
PreferencesView = require "scripts/views/preferences"
BoxView = require "scripts/views/box"
Events = require "scripts/events"

template = require "templates/app"

class App extends BaseView
  el: ".app"
  template: template

  events:
    "click .spin-link": "animateSpin"
    "click .play-button": "playAnimation"
    "mousedown .box": "startBoxDrag"

  initialize: ->
    super
    @preferences = new PreferencesView
    @boxView = new BoxView

    @$style = @$ "#animation"
    @$result = @$ "#result"
    @$box = @$result.find ".box"
    @$loop = @$ ".actions .loop-input"

  playAnimation: (options = {}) =>
    bounce = options.bounceObject or @preferences.getBounceObject()
    duration = options.duration or bounce.duration

    properties = []
    properties.push "animation-duration: #{duration}ms"
    properties.push("animation-iteration-count: infinite") if @$loop.prop("checked")

    css = """
    .box.animate {
      #{properties.join(";\n  ")};
    }
    #{bounce.getKeyframeCSS(name: "animation")}
    """

    @$style.text PrefixFree.prefixCSS(css, true)

    @$box.removeClass "animate spin"
    _.defer => @$box.addClass "animate"

  animateSpin: (e) ->
    e.preventDefault()
    @$box.removeClass "spin animate"
    _.defer => @$box.addClass "spin"

module.exports = App