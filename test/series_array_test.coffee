expect = require('chai').expect
Series = require '../src/series.coffee'

describe 'series', ->
  describe 'array', ->
    describe 'zip', ->
      samples =
        "simple case":
          input: [[1, 2], [3, 4]]
          output: [[1, 3], [2, 4]]
        "merged different length":
          input: [[1, 2], [3, 4, 5]]
          output: [[1, 3], [2, 4], [null, 5]]
        "3 arrays":
          input: [[1, 2], [3, 4], [5, 6]]
          output: [[1, 3, 5], [2, 4, 6]]
        "3 arrays that have different length":
          input: [[1, 2], [3, 4, 7, 8], [5, 6, 9]]
          output: [[1, 3, 5], [2, 4, 6], [null, 7, 9], [null, 8, null]]
      for testname, data of samples
        do (testname, data)->
          it testname, ->
            expect(Series.zip.apply(Series, data.input)).to.be.eql data.output

    describe 'range', ->
      samples =
        "simple case":
          input: [1, 10]
          output: [1..9]
        "decimal case":
          input: [0.1, 10]
          output: [0..9].map (d)-> d+ 0.1
        "with step":
          input: [1, 10, 2]
          output: [1, 3, 5, 7, 9]
      for testname, data of samples
        do (testname, data)->
          it testname, ->
            expect(Series.range.apply(Series, data.input)).to.be.eql data.output
