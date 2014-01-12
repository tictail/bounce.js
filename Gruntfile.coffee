config =
  watch:
    browserify:
      files: "app/scripts/**/*.coffee"
      tasks: ["browserify"]

    livereload:
      options:
        livereload: "<%= connect.options.livereload %>"

      files: [
        ".tmp/**/*"
        "app/index.html"
      ]

  browserify:
    dist:
      files:
        ".tmp/scripts/app.js": "app/scripts/**/*.coffee"

      options:
        debug: true
        transform: ["coffeeify"]
        extensions: [".js", ".coffee"]
        shim:
          prefixfree:
            path: "bower_components/prefixfree/prefixfree.min.js"
            exports: "PrefixFree"

        alias: [
          "bower_components/jquery/jquery.js:jquery"
          "bower_components/prefixfree/prefixfree.min.js:prefixfree"
        ]

  connect:
    options:
      port: 9000
      livereload: 35729
      hostname: "0.0.0.0"

    livereload:
      options:
        base: [
          ".tmp"
          "app/"
        ]

module.exports = (grunt) ->
  require("time-grunt") grunt
  require("load-grunt-tasks") grunt

  grunt.initConfig config

  grunt.registerTask "serve", [
    "browserify"
    "connect:livereload"
    "watch"
  ]
