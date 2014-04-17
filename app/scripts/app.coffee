require "scripts/setup"

PrefixFree = require "prefixfree"

BaseView = require "scripts/views/base"
PreferencesView = require "scripts/views/preferences"
Events = require "scripts/events"

template = require "templates/app"

class App extends BaseView
  el: ".app"
  template: template

  initialize: ->
    super
    new PreferencesView
    @$style = $ "#animation"
    Events.on "playAnimation", @onPlayAnimation

  onPlayAnimation: ({bounce, duration}) =>
    css = """
    .animate .box { animation-duration: #{duration}ms; }
    #{bounce.getKeyframeCSS(name: "animation")}
    """

    @$style.text PrefixFree.prefixCSS(css, true)

    $body = $ "body"

    $body.removeClass "animate"
    $body[0].offsetWidth
    $body.addClass "animate"

module.exports = App