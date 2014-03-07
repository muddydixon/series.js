expect = require('chai').expect
Series = require '../src/series.coffee'

describe 'series', ->
  describe 'time interval methods', ->
    testDate = new Date(2013, 5, 24, 3, 45, 23)
    samples =
      'minute': new Date(2013, 5, 24, 3, 45,  0)
      'hour':   new Date(2013, 5, 24, 3,  0,  0)
      'day':    new Date(2013, 5, 24, 0,  0,  0)
      'week':   new Date(2013, 5, 23, 0,  0,  0)
      'month':  new Date(2013, 5,  1, 0,  0,  0)
      'year':   new Date(2013, 0,  1, 0,  0,  0)

    for method, answer of samples
      do (method, answer)->
        it "time interval #{method}", ->
          expect(Series[method](testDate)).to.be.deep.eql answer

  describe 'time format methods', ->
    testDate = new Date(2013, 7, 20, 14, 45, 23, 128)
    samples =
      '%a': 'Tue'
      '%A': 'Tuesday'
      '%b': 'Aug'
      '%B': 'August'
      '%c': 'Tue Aug 20 14:45:23 2013'
      '%d': '20'
      '%e': '20'
      '%H': '14'
      '%I': '02'
      '%j': '232'
      '%L': '128'
      '%m': '08'
      '%M': '45'
      '%p': 'PM'
      '%S': '23'
      '%w': '2'
      '%x': '08/20/2013'
      '%X': '14:45:23'
      '%y': '13'
      '%Y': '2013'
      # '%Z': '-540'
      '%%': '%'
      '%Y-%m-%d': '2013-08-20'
      '%Y/%m/%d': '2013/08/20'
      '%H %M %S': '14 45 23'
      '%%%H': '%14'

    for f, answer of samples
      do (f, answer)->
        it "format(#{f})", ->
          format = Series.format(f)
          expect(format(testDate)).to.be.eql answer
