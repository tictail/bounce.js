class Helpers
  sign: (value) -> if value < 0 then -1 else 1

  numBounces: (easing) ->
    bounces = 0
    values = []

    for i in [0..1] by 0.001
      values.push easing.calculate(i)
      len = values.length
      continue unless len > 2

      signA = @sign values[len - 2] - values[len - 3]
      signB = @sign values[len - 1] - values[len - 2]
      if signA isnt signB
        bounces++

    bounces

  numHardBounces: (easing) ->


module.exports = new Helpers