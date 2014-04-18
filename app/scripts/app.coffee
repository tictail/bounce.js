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

    @boxStartPos =
      x: @$box.offset().left + @$box.width() / 2
      y: @$box.offset().top + @$box.height() / 2

    @grabOffset =
      x: e.offsetX - @$box.width() / 2
      y: e.offsetY - @$box.height() / 2

    @grabDistance = Math.sqrt \
      @grabOffset.x ** 2 + @grabOffset.y ** 2

    @$box.css "transform-origin", "#{e.offsetX}px #{e.offsetY}px"

    @dragOffset = null

    $(document).on
      "mousemove.boxdrag": @boxDrag
      "mouseup.boxdrag": @stopBoxDrag

    $("body").addClass "dragging"

  stopBoxDrag: (e) =>
    return unless @isDragging

    @isDragging = false
    if @dragOffset
      cos = Math.cos @dragAngle
      sin = Math.sin @dragAngle

      # Rotate the grabOffset to calculate translation correction after
      # changing the transform origin
      correction =
        x: @grabOffset.x - (@grabOffset.x * cos - @grabOffset.y * sin)
        y: @grabOffset.y - (@grabOffset.x * sin + @grabOffset.y * cos)

      @$box.css "transform-origin", ""
      @$box.css "transform", """
        translate(#{@dragOffset.x + correction.x}px, #{@dragOffset.y + correction.y}px)
        rotate(#{@dragAngle}rad)
      """

      # Rotate back to the closest 90 degree multiple
      deg =  @dragAngle / Math.PI * 180
      if deg %% 90 > 45
        deg += 90 - deg %% 90
      else
        deg -= deg %% 90

      bounce = new Bounce()
      bounce.translate(
        stiffness: 1.5
        from:
          x: @dragOffset.x + correction.x
          y: @dragOffset.y + correction.y
        to: { x: 0, y: 0 }
      ).rotate(
        stiffness: 0.5
        from: @dragAngle / Math.PI * 180
        to: deg
      )

      @playAnimation bounceObject: bounce, duration: 600
      _.defer => @$box.css "transform", ""
      setTimeout (=> @$result.removeClass "animate"), 610

    $(document).off ".boxdrag"
    $("body").removeClass "dragging"

  boxDrag: (e) =>
    delta =
      x: e.clientX - @dragStartPos.x
      y: e.clientY - @dragStartPos.y

    distance = Math.sqrt(delta.x ** 2 + delta.y ** 2)
    dampenedDistance = 250 * (1 - Math.E ** (-0.002 * distance))

    angle = Math.atan2 delta.y, delta.x

    if @grabDistance > 10
      centerDelta =
        x: e.clientX - @boxStartPos.x
        y: e.clientY - @boxStartPos.y

      centerDistance = Math.sqrt centerDelta.x ** 2 + centerDelta.y ** 2
      dotProduct = centerDelta.x * @grabOffset.x + centerDelta.y * @grabOffset.y
      determinant = centerDelta.x * @grabOffset.y - centerDelta.y * @grabOffset.x

      @dragAngle = -Math.atan2 determinant, dotProduct
    else
      @dragAngle = 0

    @dragOffset =
      x: Math.cos(angle) * dampenedDistance
      y: Math.sin(angle) * dampenedDistance

    @$box.css "transform", """
      translate(#{@dragOffset.x}px, #{@dragOffset.y}px)
      rotate(#{@dragAngle}rad)
    """

module.exports = App