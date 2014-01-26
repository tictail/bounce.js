require "scripts/setup"

PrefixFree = require "prefixfree"

BaseView = require "scripts/views/base"
PreferencesView = require "scripts/views/preferences"
Events = require "scripts/events"

template = require "templates/app"

class App extends BaseView
  PRESET_ALPHA: 0.05
  el: ".app"
  template: template

  initialize: ->
    super
    new PreferencesView
    @$style = $ "#animation"
    Events.on "playAnimation", @onPlayAnimation

  onPlayAnimation: ({keyframes, duration}) =>
    @$style.text """
    .animate .box { -webkit-animation-duration: #{duration}ms; }
    #{PrefixFree.prefixCSS(keyframes, true)}
    """
    $("body").removeClass "animate"
    setTimeout (-> $("body").addClass "animate"), 0

module.exports = App