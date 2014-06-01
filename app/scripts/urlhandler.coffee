_ = require "underscore"

class URLHandler
  @_shortKeys:
    "type": "T"
    "easing": "e"
    "duration": "d"
    "delay": "D"
    "from": "f"
    "to": "t"
    "bounces": "b"
    "stiffness": "s"

  @_shortValues:
    "bounce": "b"
    "sway": "s"
    "hardbounce": "B"
    "hardsway": "S"
    "scale": "c"
    "skew": "k"
    "translate": "t"
    "rotate": "r"

  @_longKeys: _.invert URLHandler._shortKeys
  @_longValues: _.invert URLHandler._shortValues

  constructor: ->

  encodeURL: (serialized, options = {}) ->
    encoded = {}
    encoded.l = 1 if options.loop
    encoded.s = for opts in serialized
      shortKeys = {}
      for key, value of opts
        shortKeys[URLHandler._shortKeys[key] or key] =
          URLHandler._shortValues[value] or value

      shortKeys

    stringified = JSON.stringify(encoded)
    # Remove double quotes in properties
    stringified = stringified.replace(/(\{|,)"([a-z0-9]+)"(:)/gi, "$1$2$3")
    encodeURIComponent stringified

  decodeURL: (str) ->
    # Add back the double quotes in properties
    str = decodeURIComponent str
    json = str.replace(/(\{|,)([a-z0-9]+)(:)/gi, "$1\"$2\"$3")
    decoded = JSON.parse(json)
    unshortened = for options in decoded.s
      longKeys = {}
      for key, value of options
        longKeys[URLHandler._longKeys[key] or key] =
          URLHandler._longValues[value] or value

      longKeys

    {
      serialized: unshortened
      loop: decoded.l
    }

module.exports = new URLHandler