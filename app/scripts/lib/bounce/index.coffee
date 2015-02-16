Matrix4D = require "./math/matrix4d"

ComponentClasses =
  scale: require "./components/scale"
  rotate: require "./components/rotate"
  translate: require "./components/translate"
  skew: require "./components/skew"

class Bounce
  @FPS: 30
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

  applyTo: (elements, options = {}) ->
    @define()
    elements = [elements] unless elements.length
    prefixes = @getPrefixes()

    deferred = null
    if window.jQuery and window.jQuery.Deferred
      deferred = new window.jQuery.Deferred()

    for element in elements
      for prefix in prefixes.animation
        css = [@name, "#{@duration}ms", "linear", "both"]
        css.push("infinite") if options.loop
        element.style["#{prefix}animation"] = css.join " "

    unless options.loop
      setTimeout (=>
        @remove() if options.remove
        options.onComplete?()
        deferred.resolve() if deferred
      ), @duration

    deferred

  remove: ->
    return unless @styleElement

    if @styleElement.remove
      @styleElement.remove()
    else
      @styleElement.parentNode?.removeChild @styleElement

  getPrefixes: (force) ->
    prefixes =
      transform: [""]
      animation: [""]

    style = document.createElement("dummy").style

    if force or (not ("transform" of style) and "webkitTransform" of style)
      prefixes.transform = ["-webkit-", ""]

    if force or (not ("animation" of style) and "webkitAnimation" of style)
      prefixes.animation = ["-webkit-", ""]

    prefixes

  getKeyframeCSS: (options = {}) ->
    @name = options.name or Bounce.generateName()

    prefixes =
      transform: [""]
      animation: [""]

    if options.prefix or options.forcePrefix
      prefixes = @getPrefixes(options.forcePrefix)

    keyframeList = []
    keyframes = @getKeyframes options
    for key in @keys
      matrix = keyframes[key]
      transformString = "matrix3d#{matrix}"
      transforms = []
      for prefix in prefixes.transform
        transforms.push "#{prefix}transform: #{transformString};"

      keyframeList.push \
        "#{Math.round(key * 100 * 100) / 100}% { #{transforms.join " "} }"

    animations = []
    for prefix in prefixes.animation
      animations.push \
        "@#{prefix}keyframes #{@name} { \n  #{keyframeList.join("\n  ")} \n}"

    animations.join "\n\n"

  getKeyframes: (options = {}) ->
    keys = [0, 1]

    if options.optimized
      for component in @components
        componentKeys = component.easingObject.findOptimalKeyPoints().map (key) =>
          (key * component.duration / @duration) + (component.delay / @duration)

        if component.delay
          componentKeys.push((component.delay / @duration) - 0.001)

        keys = keys.concat componentKeys
    else
      frames = Math.round((@duration / 1000) * Bounce.FPS)
      keys.push(i / frames) for i in [0..frames]

    keys = keys.sort (a, b) -> a - b

    @keys = []
    keyframes = {}
    for key in keys
      continue if keyframes[key]
      matrix = new Matrix4D().identity()

      for component in @components
        currentTime = key * @duration
        continue if (component.delay - currentTime) > 1e-8 # Account for rounding errors
        ratio = (key - component.delay / @duration) / (component.duration / @duration)
        matrix.multiply \
          component.getEasedMatrix(ratio)

      @keys.push key
      keyframes[key] = matrix.transpose().toFixed 3


    keyframes

  @generateName: ->
    "animation-#{Bounce.counter++}"

  @isSupported: ->
    style = document.createElement("dummy").style

    propertyLists = [
      ["transform", "webkitTransform"]
      ["animation", "webkitAnimation"]
    ]

    for propertyList in propertyLists
      propertyIsSupported = false
      for property in propertyList
        propertyIsSupported ||= property of style

      return false unless propertyIsSupported

    true

module.exports = Bounce
