$ = require("jquery")
PrefixFree = require "prefixfree"

class App
  PRESET_ALPHA: 0.05

  $inputs:
    keyframes: $ "#keyframes"
    bounces: $ "#bounces"
    type: $ "#type"
    start: $ "#start"
    end: $ "#end"
    play: $ "#play"

  $output: $ "#output"

  valueFormatters:
    scale: (n) -> "scale(#{n})"
    rotate: (n) -> "rotate(#{n}deg)"

  constructor: ->
    @$style = $("<style>").attr("id", "animation").appendTo "body"

    @$inputs.play.on "click", @playAnimation
    @playAnimation()

  generateKeyframes: ({numKeyframes, bounces, type, start, end}) ->
    diff = end - start

    a = @PRESET_ALPHA
    limit = Math.floor(Math.log(0.005) / -a)
    w = bounces * Math.PI / limit

    keyframes = []
    for i in [0...numKeyframes]
      t = i * limit / numKeyframes
      value = start + diff - diff * Math.pow(Math.E, -a*t) * Math.cos(w*t)
      keyframes.push "#{i * 100 / numKeyframes}% { transform: #{@valueFormatters[type](value)}; }"

    keyframes.push "100% { transform: #{@valueFormatters[type](end)}; }"
    "@keyframes animate { \n  #{keyframes.join("\n  ")} \n}"

  playAnimation: =>
    keyframes = @generateKeyframes
      numKeyframes: @$inputs.keyframes.val()
      bounces: parseInt(@$inputs.bounces.val())
      type: @$inputs.type.val()
      start: parseFloat(@$inputs.start.val())
      end: parseFloat(@$inputs.end.val())

    @$style.text PrefixFree.prefixCSS(keyframes, true)
    @$output.val keyframes

    $("body").removeClass "animate"
    setTimeout (-> $("body").addClass "animate"), 0

new App