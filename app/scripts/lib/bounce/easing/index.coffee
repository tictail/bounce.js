MathHelpers = require "../math/helpers"

class Easing
  calculate: (ratio) ->
    ratio

  serialize: ->
    {}

  # Find the optimal keypoints to approximate the easing curve with
  # line segments. This is done in two steps:
  #
  #   1. Set keypoints at the start, end and turning points of the curve
  #
  #   2. For each pair of subsequent keypoints, compare the area between
  #      the curve and a straight line between these keypoints. If it is above
  #      a given threshold, insert a new keypoint in the middle of these two.
  #      This process is repeated until the area has been reduced below the
  #      threshold for all pairs of subsequent keypoints.
  #
  findOptimalKeyPoints: (threshold = 1.0, resolution = 1000) ->
    keyPoints = [0]
    values = (@calculate(i / resolution) for i in [0...resolution])

    keyPoints = keyPoints.concat MathHelpers.findTurningPoints(values)
    keyPoints.push resolution - 1

    i = 0
    loops = 1000
    while loops--
      break if i is keyPoints.length - 1

      area = MathHelpers.areaBetweenLineAndCurve(
        values, keyPoints[i], keyPoints[i + 1])

      if area <= threshold
        i++
      else
        halfway = Math.round(keyPoints[i] + (keyPoints[i + 1] - keyPoints[i]) / 2)
        keyPoints.splice(i + 1, 0, halfway)

    return [] if loops is 0
    result = (keyPoint / (resolution - 1) for keyPoint in keyPoints)

module.exports = Easing