require "scripts/setup"

_ = require "underscore"
PrefixFree = require "prefixfree"

BaseView = require "scripts/views/base"
PreferencesView = require "scripts/views/preferences"
Events = require "scripts/events"

template = require "templates/app"

class App extends BaseView
  el: ".app"
  template: template

  events:
    "click .spin-link": "animateSpin"
    "click .play-button": "playAnimation"

  initialize: ->
    super
    @preferences = new PreferencesView

    @$style = $ "#animation"
    @$result = $ "#result"

    console.log $ ".play-button"

  playAnimation: =>
    bounce = @preferences.getBounceObject()

    css = """
    .animate .box {
      animation-duration: #{@preferences.getAnimationDuration()}ms;
    }
    #{bounce.getKeyframeCSS(name: "animation")}
    """

    @$style.text PrefixFree.prefixCSS(css, true)

    @$result.removeClass "animate spin"
    _.defer => @$result.addClass "animate"

  animateSpin: (e) ->
    e.preventDefault()
    @$result.removeClass "spin animate"
    _.defer => @$result.addClass "spin"


module.exports = App