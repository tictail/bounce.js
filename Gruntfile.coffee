config =
  watch:
    browserify:
      files: [
        "app/scripts/**/*.coffee"
        "app/templates/**/*.hbs"
      ]
      tasks: ["browserify"]

    styles:
      files: [
        "app/styles/*.scss"
      ]
      tasks: ["compileStyles"]

    livereload:
      options:
        livereload: "<%= connect.options.livereload %>"

      files: [
        ".tmp/**/*"
        "app/index.html"
      ]

  browserify:
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
        "bower_components/chosen/chosen.jquery.js:chosen"
        "bower_components/jquery-icheck/icheck.js:icheck"
        "bower_components/nouislider/jquery.nouislider.min.js:nouislider"
        "bower_components/backbone/backbone.js:backbone"
        "bower_components/prefixfree/prefixfree.min.js:prefixfree"
        "app/scripts/lib/bounce/index.coffee:bounce"
      ]
      aliasMappings: [
        cwd: "app/"
        src: ["**/*.coffee", "**/*.js", "**/*.hbs"]
        dest: ""
      ]

    all:
      files:
        ".tmp/scripts/app.js": [
          "app/scripts/**/*.coffee"
          "app/templates/**/*.hbs"
        ]

    dist:
      options: { debug: false }
      files:
        ".tmp/scripts/app.js": [
          "app/scripts/**/*.coffee"
          "app/templates/**/*.hbs"
        ]

    bounce:
      options:
        debug: false
        alias: []
        aliasMappings: []
        shim: {}
        standalone: "Bounce"

      files:
        ".tmp/bounce.js": ["app/scripts/lib/bounce/index.coffee"]

    test:
      files:
        ".tmp/scripts/tests.js": [
          "app/scripts/lib/bounce/index.coffee"
          "test/**/*.coffee"
        ]

  connect:
    options:
      port: 9000
      livereload: 35730
      hostname: "0.0.0.0"

    livereload:
      options:
        base: [
          ".tmp"
          "app/"
        ]

    test:
      options:
        port: 9001
        base: [
          ".tmp"
          "app"
          "test"
          "node_modules"
        ]

  mocha:
    all:
      options:
        run: true
        bail: false
        log: true
        reporter: "Spec"
        urls: ["http://localhost:9001/test.html"]

  compass:
    app:
      options:
        sassDir: "app/styles"
        imagesDir: "app/images"
        cssDir: ".tmp/styles"
        specify: ["app/styles/styles.scss"]

  concat:
    css:
      src: [
        "bower_components/chosen/chosen.min.css"
        "bower_components/nouislider/jquery.nouislider.css"
        ".tmp/styles/styles.css"
      ]
      dest: ".tmp/styles/styles.css"

  clean:
    dist: ["dist"]

  copy:
    dist:
      files: [
        { expand: true, cwd: ".tmp/", src: "**/*", dest: "dist/" }
        { src: "app/index.html", dest: "dist/index.html" }
      ]

  uglify:
    dist:
      files:
        "dist/scripts/app.js": "dist/scripts/app.js"
    bounce:
      files:
        ".tmp/bounce.min.js": ".tmp/bounce.js"

  cssmin:
    dist:
      files:
        "dist/styles/styles.css": "dist/styles/styles.css"

  autoprefixer:
    options:
      browsers: ["last 2 versions"]
    app:
      src: ".tmp/styles/styles.css"


module.exports = (grunt) ->
  require("time-grunt") grunt
  require("load-grunt-tasks") grunt

  grunt.initConfig config

  grunt.registerTask "serve", [
    "browserify:all"
    "compileStyles"
    "connect:livereload"
    "watch"
  ]

  grunt.registerTask "test", [
    "browserify:test"
    "connect:test"
    "mocha"
  ]

  grunt.registerTask "dist", [
    "clean:dist"
    "browserify:dist",
    "compileStyles",
    "copy:dist",
    # "uglify:dist",
    "cssmin:dist"
  ]

  grunt.registerTask "package", [
    "browserify:bounce",
    "uglify:bounce"
  ]

  grunt.registerTask "watch:test", ->
    config =
      test:
        files: ["app/scripts/**/*.coffee", "test/**/*.coffee"]
        tasks: "test"

    grunt.config "watch", config
    grunt.task.run "watch"

  grunt.registerTask "compileStyles", [
    "compass"
    "autoprefixer"
    "concat:css"
  ]
