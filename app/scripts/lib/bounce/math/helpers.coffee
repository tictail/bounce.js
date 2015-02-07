class MathHelpers
  sign: (value) ->
    return -1 if value < 0
    return 1

  # Find the turning points in a curve defined
  # by the given set of values
  findTurningPoints: (values) ->
    turningPoints = []

    for i in [1...(values.length - 1)]
      signA = @sign(values[i] - values[i-1])
      signB = @sign(values[i+1] - values[i])

      turningPoints.push(i) if signA isnt signB

    turningPoints

  # Calculate the area between a curve defined
  # by a list of values, and a line between a given
  # start and end point on that curve.
  areaBetweenLineAndCurve: (values, start, end) ->
    length = end - start
    yStart = values[start]
    yEnd = values[end]
    area = 0

    for i in [0..length]
      curveValue = values[start + i]
      lineValue = yStart + (i / length) * (yEnd - yStart)

      area += Math.abs(lineValue - curveValue)

    area

module.exports = new MathHelpers