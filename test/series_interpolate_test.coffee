expect = require('chai').expect
Series = require '../src/series.coffee'

describe 'series', ->
  describe 'interpolate', ->
    describe 'number', ->
      tests =
        "interpolate numbers":
          in: [2, 12]
          conds: [.4]
          outs: [6]
        # "interpolate string to numbers":
        #   in: ["2", "12"]
        #   cond: [.4]
        #   out: [6]
      for testname, data of tests
        do (testname, data)->
          it testname, ->
            interpolate = Series.interpolate.apply Series, data.in
            for cond, idx in data.conds
              expect(interpolate(cond)).to.be.eql data.outs[idx]

    describe 'array', ->
      tests =
        "interpolate defined elements":
          in: [[2, 12], [4, 24]]
          conds: [.5]
          outs: [[3, 18]]
        "merges non-shared elements":
          in: [[2, 12], [4, 24, 12]]
          conds: [.5]
          outs: [[3, 18, 12]]
        "decimal elements":
          in: [[0.5, 0.5], [0.1, 0.9]]
          conds: [.5]
          outs: [[0.3, 0.7]]
        "decimal three elements":
          in: [[1/3, 1/3, 1/3], [0.01, 0.3, 0.59]]
          conds: [.9, .5, .1]
          outs: [
            [0.042333333333333334, 0.30333333333333334, 0.5643333333333334],
            [0.17166666666666666, 0.31666666666666665, 0.46166666666666667],
            [0.301, 0.32999999999999996, 0.359]]
      for testname, data of tests
        do (testname, data)->
          it testname, ->
            interpolate = Series.interpolate.apply Series, data.in
            for cond, idx in data.conds
              expect(interpolate(cond)).to.be.eql data.outs[idx]
