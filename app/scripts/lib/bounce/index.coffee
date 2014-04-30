Matrix4D = require "./math/matrix4d"

ComponentClasses =
  scale: require "./components/scale"
  rotate: require "./components/rotate"
  translate: require "./components/translate"
  skew: require "./components/skew"

class Bounce
  @counter: 1
  components: null
  duration: 0

  constructor: ->
    @components = []

  scale: (options) ->
    @addComponent new ComponentClasses["scale"](options)

  rotate: (options) ->
    @addComponent new ComponentClasses["rotate"](options)

  translate: (options) ->
    @addComponent new ComponentClasses["translate"](options)

  skew: (options) ->
    @addComponent new ComponentClasses["skew"](options)

  addComponent: (component) ->
    @components.push component
    @updateDuration()
    this

  serialize: ->
    serialized = []
    serialized.push(component.serialize()) for component in @components
    serialized

  deserialize: (serialized) ->
    for options in serialized
      @addComponent new ComponentClasses[options.type](options)

    this

  updateDuration: ->
    @duration = @components
      .map (component) -> component.duration + component.delay
      .reduce (a, b) -> Math.max a, b

  define: (name) ->
    @name = name or Bounce.generateName()
    @styleElement = document.createElement "style"
    @styleElement.innerHTML = @getKeyframeCSS name: @name, prefix: true

    document.body.appendChild @styleElement
    this

  remove: ->
    @styleElement?.remove()

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

    keyframeList = []
    keyframes = @getKeyframes()
    for key in @keys
      matrix = keyframes[key]
      transformString = "matrix3d#{matrix}"
      keyframeList.push \
        "#{Math.round(key * 100 * 1e6) / 1e6}% { #{prefixes.transform}transform: #{transformString}; }"

    "@#{prefixes.animation}keyframes #{@name} { \n  #{keyframeList.join("\n  ")} \n}"

  getKeyframes: ->
    # TODO: Clean this up, move logic to components
    keys = [0]
    for component in @components
      startKey = (component.delay / @duration) * 100
      endKey = ((component.delay + component.duration) / @duration) * 100

      numKeyframes = component.easingObject.bounces * 8

      keys.push(startKey + (i / numKeyframes) * (endKey - startKey)) for i in [0..numKeyframes]
      keys.push(startKey - 0.01) unless startKey is 0

    keys = keys.sort((a, b) -> a - b).map((i) -> i / 100)

    @keys = @_unique(keys)

    keyframes = {}
    for i in @keys
      matrix = new Matrix4D().identity()

      for component in @components
        currentTime = i * @duration
        continue if (component.delay - currentTime) > 1e-8 # Account for rounding errors
        ratio = (i - component.delay / @duration) / (component.duration / @duration)
        matrix.multiply \
          component.getEasedMatrix(ratio)

      keyframes[i] = matrix.transpose().toFixed 5

    keyframes

  @generateName: ->
    "animation-#{Bounce.counter++}"

  @isSupported: ->
    style = document.createElement("dummy").style

    propertyLists = [
      ["transform", "webkitTransform"],
      ["animation", "webkitAnimation"]
    ]
    for propertyList in propertyLists
      propertyIsSupported = false
      for property in propertyList
        propertyIsSupported ||= property of style

      return false unless propertyIsSupported

    true

  _unique: (list) ->
    seen = {}
    list.filter (i) ->
      isUnique = not seen[i]
      seen[i] = true
      isUnique

module.exports = Bounce
