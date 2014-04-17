require "scripts/setup"

_ = require "underscore"
PrefixFree = require "prefixfree"
Bounce = require "bounce"

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
    "mousedown .box": "startBoxDrag"

  initialize: ->
    super
    @preferences = new PreferencesView

    @$style = $ "#animation"
    @$result = $ "#result"
    @$box = @$result.find ".box"


  playAnimation: (options = {}) =>
    bounce = options.bounceObject or @preferences.getBounceObject()
    duration = options.duration or @preferences.getAnimationDuration()

    css = """
    .animate .box {
      animation-duration: #{duration}ms;
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

  startBoxDrag: (e) ->
    return if @isDragging
    @$result.removeClass "animate spin"

    @isDragging = true
    @dragStartPos =
      x: e.clientX
      y: e.clientY

    @dragOffset = null

    $(document).on
      "mousemove.boxdrag": @boxDrag
      "mouseup.boxdrag": @stopBoxDrag

    $("body").addClass "dragging"

  stopBoxDrag: (e) =>
    return unless @isDragging

    @isDragging = false
    if @dragOffset
      bounce = new Bounce()
      bounce.translate
        stiffness: 1.5
        from: @dragOffset
        to: { x: 0, y: 0 }

      @playAnimation bounceObject: bounce, duration: 600
      _.defer => @$box.css "transform", ""

    $(document).off "mousemove.boxdrag"
    $("body").removeClass "dragging"

  boxDrag: (e) =>
    delta =
      x: e.clientX - @dragStartPos.x
      y: e.clientY - @dragStartPos.y

    distance = Math.sqrt(Math.pow(delta.x, 2) + Math.pow(delta.y, 2))
    constrainedDistance = distance * Math.pow(Math.E, -0.002 * distance)

    angle = Math.atan2 delta.y, delta.x
    @dragOffset =
      x: Math.cos(angle) * constrainedDistance
      y: Math.sin(angle) * constrainedDistance

    @$box.css "transform", "translate(#{@dragOffset.x}px, #{@dragOffset.y}px"

module.exports = App