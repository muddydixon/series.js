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
      for testname, data of tests
        do (testname, data)->
          it testname, ->
            interpolate = Series.interpolate.apply Series, data.in
            for cond, idx in data.conds
              expect(interpolate(cond)).to.be.eql data.outs[idx]
