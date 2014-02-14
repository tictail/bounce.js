Matrix4D = require "./math/matrix4d"

Scale = require "./components/scale"
Rotate = require "./components/rotate"
Translate = require "./components/translate"
Skew = require "./components/skew"

class Bounce
  @counter: 1
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

  define: (name) ->
    @name = name or Bounce.generateName()
    @styleElement = document.createElement "style"
    @styleElement.innerHTML = @getKeyframeCSS name: @name, prefix: true

    document.body.appendChild @styleElement
    this

  getPrefixes: ->
    prefixes =
      transform: ""
      animation: ""

    style = document.createElement("dummy").style

    if not ("transform" of style) and "webkitTransform" of style
      prefixes.transform = "-webkit-"

    if not ("animation" of style) and "webkitAnimation" of style
      prefixes.animation = "-webkit-"

    prefixes

  getKeyframeCSS: (options = {}) ->
    @name = options.name or Bounce.generateName()

    prefixes =
      transform: ""
      animation: ""

    if options.prefix
      prefixes = @getPrefixes()

    keyframes = []
    for keyframe, matrix of @getKeyframes()
      transformString = "matrix3d#{matrix}"
      keyframes.push \
        "#{keyframe}% { #{prefixes.transform}transform: #{transformString}; }"

    "@#{prefixes.animation}keyframes #{@name} { \n  #{keyframes.join("\n  ")} \n}"

  getKeyframes: ->
    keyframes = {}
    for i in [0..100] by 4
      matrix = new Matrix4D().identity()

      for component in @components
        matrix.multiply component.getEasedMatrix(i / 100)

      keyframes["#{i}"] = matrix.transpose().toFixed 5

    keyframes

  @generateName: ->
    "animation-#{Bounce.counter++}"

module.exports = Bounce
