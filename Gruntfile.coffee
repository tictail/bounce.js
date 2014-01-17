config =
  watch:
    browserify:
      files: [
        "app/scripts/**/*.coffee"
        "app/templates/**/*.hbs"
      ]
      tasks: ["browserify"]

    livereload:
      options:
        livereload: "<%= connect.options.livereload %>"

      files: [
        ".tmp/**/*"
        "app/index.html"
      ]

  browserify:
    all:
      files:
        ".tmp/scripts/app.js": [
          "app/scripts/**/*.coffee"
          "app/templates/**/*.hbs"
        ]

      options:
        debug: true
        transform: ["coffeeify", "hbsfy"]
        extensions: [".js", ".coffee", ".hbs"]
        shim:
          prefixfree:
            path: "bower_components/prefixfree/prefixfree.min.js"
            exports: "PrefixFree"

        alias: [
          "bower_components/jquery/jquery.js:jquery"
          "bower_components/backbone/backbone.js:backbone"
          "bower_components/prefixfree/prefixfree.min.js:prefixfree"
        ]
        aliasMappings: [
          cwd: "app/"
          src: ["**/*.coffee", "**/*.js", "**/*.hbs"]
          dest: ""
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
