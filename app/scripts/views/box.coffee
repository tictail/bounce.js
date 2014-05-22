_ = require "underscore"
Bounce = require "bounce"
BaseView = require "scripts/views/base"

class BoxView extends BaseView
  el: "#result .box"

  events:
    "mousedown": "startDrag"

  startDrag: (e) ->
    return if @isDragging
    @$el.removeClass "animate spin"

    @isDragging = true
    @dragStartPos =
      x: e.clientX
      y: e.clientY

    @boxStartPos =
      x: @$el.offset().left + @$el.width() / 2
      y: @$el.offset().top + @$el.height() / 2

    @grabOffset =
      x: e.offsetX - @$el.width() / 2
      y: e.offsetY - @$el.height() / 2

    @grabDistance = Math.sqrt \
      @grabOffset.x ** 2 + @grabOffset.y ** 2

    @$el.css "transform-origin", "#{e.offsetX}px #{e.offsetY}px"

    @dragOffset = null

    $(document).on
      "mousemove.boxdrag": @drag
      "mouseup.boxdrag": @stopDrag

    $("body").addClass "dragging"

  stopDrag: (e) =>
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

      @$el.css "transform-origin", ""
      @$el.css "transform", """
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

      window.App.playAnimation
        bounceObject: bounce
        duration: 600
        updateURL: false

      _.defer => @$el.css "transform", ""
      setTimeout (=> @$el.removeClass "animate"), 610

    $(document).off ".boxdrag"
    $("body").removeClass "dragging"

  drag: (e) =>
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
      x: Math.round(Math.cos(angle) * dampenedDistance)
      y: Math.round(Math.sin(angle) * dampenedDistance)

    @$el.css "transform", """
      translate(#{Math.round(@dragOffset.x)}px, #{Math.round(@dragOffset.y)}px)
      rotate(#{@dragAngle.toPrecision(2)}rad)
    """

module.exports = BoxView