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


  #   @$style = $("<style>").attr("id", "animation").appendTo "body"

  #   @$inputs.play.on "click", @playAnimation
  #   @playAnimation()

  # generateKeyframes: ({numKeyframes, bounces, type, start, end}) ->
  #   diff = end - start

  #   a = @PRESET_ALPHA
  #   limit = Math.floor(Math.log(0.005) / -a)
  #   w = bounces * Math.PI / limit

  #   keyframes = []
  #   for i in [0...numKeyframes]
  #     t = i * limit / numKeyframes
  #     value = start + diff - diff * Math.pow(Math.E, -a*t) * Math.sin(w*t)
  #     keyframes.push "#{i * 100 / numKeyframes}% { transform: #{@valueFormatters[type](value)}; }"

  #   keyframes.push "100% { transform: #{@valueFormatters[type](end)}; }"
  #   "@keyframes animate { \n  #{keyframes.join("\n  ")} \n}"

  # playAnimation: =>
  #   keyframes = @generateKeyframes
  #     numKeyframes: @$inputs.keyframes.val()
  #     bounces: parseInt(@$inputs.bounces.val())
  #     type: @$inputs.type.val()
  #     start: parseFloat(@$inputs.start.val())
  #     end: parseFloat(@$inputs.end.val())

  #   @$style.text PrefixFree.prefixCSS(keyframes, true)
  #   @$output.val keyframes

  #   $("body").removeClass "animate"
  #   setTimeout (-> $("body").addClass "animate"), 0

module.exports = App