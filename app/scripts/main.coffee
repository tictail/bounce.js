$ = require("jquery")

numKeyframes = 100
values = []

start = 0.5
end = 1
bounces = 4

diff = end - start

a = 0.05
tEnd = Math.floor(Math.log(0.005) / -a)
w = bounces * Math.PI / tEnd

console.log tEnd
for t in [0..tEnd]
  values.push start + diff - diff * Math.pow(Math.E, -a*t) * Math.cos(w*t)


keyframes = []
for t in [0...numKeyframes]
  value = values[Math.floor(t * values.length / numKeyframes)]

  keyframes.push "#{t * 100 / numKeyframes}% { -webkit-transform: scale(#{value}); }"

keyframes.push "100% { -webkit-transform: scale(#{end}); }"

css = "@-webkit-keyframes move { \n  #{keyframes.join("\n  ")} \n}"
console.log css
$("<style>").text(css).appendTo("body")
$("body").addClass "animate"

$(document).on "keypress", $("body").toggleClass.bind($("body"), "animate")

