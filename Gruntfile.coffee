module.exports = (grunt)->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      lib:
        options:
          bare: false
        files:
          'lib/series.js': 'src/series.coffee'

    simplemocha:
      all:
        src: 'test/**/*_test.coffee'
      options:
        ui: 'bdd'
        reporter: 'spec'

    watch:
      test:
        files: ['src/*.coffee', 'test/*_test.coffee', 'Gruntfile.coffee']
        tasks: ['simplemocha']
      build:
        files: ['src/*.coffee', 'test/*_test.coffee']
        tasks: ['coffee']

    clean:
      files: ['lib']

  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['simplemocha', 'coffee']
  grunt.registerTask 'test', ['simplemocha']
