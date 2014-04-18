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

    @$style = $ "#animation"
    @$result = $ "#result"
    @$box = @$result.find ".box"

  playAnimation: (options = {}) =>
    bounce = options.bounceObject or @preferences.getBounceObject()
    duration = options.duration or @preferences.getAnimationDuration()

    css = """
    .box.animate {
      animation-duration: #{duration}ms;
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