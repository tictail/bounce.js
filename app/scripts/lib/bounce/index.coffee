Matrix4D = require "./math/matrix4d"

Scale = require "./components/scale"
Rotate = require "./components/rotate"
Translate = require "./components/translate"
Skew = require "./components/skew"

class Bounce
  components: null

  constructor: ->
    @components = []

  scale: (options) ->
    @addComponent new Scale(options)

  rotate: (options) ->
    @addComponent new Rotate(options)

  translate: (options) ->
    @addComponent new Translate(options)

  skew: (options) ->
    @addComponent new Skew(options)

  addComponent: (component) ->
    @components.push component
    this

  getKeyframes: ->
    keyframes = {}
    for i in [0..100] by 4
      matrix = new Matrix4D().identity()

      for component in @components
        matrix.multiply component.getEasedMatrix(i / 100)

      keyframes["#{i}"] = matrix.transpose().toFixed 5

    keyframes

module.exports = Bounce