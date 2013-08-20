expect = require('chai').expect
Series = require '../src/series.coffee'

describe 'series', ->
  it 'create instance', ->
    s = new Series()
    expect(s).to.be.an.instanceof Series
    s.put 1
    expect(s).have.length 1
    s.put 1
    expect(s).have.length 2

  it 'accessors', ->
    Series.y((d)-> d.v)
    expect(Series.y().toString()).to.be.eql ((d)-> d.v).toString()
    Series.t((d)-> d.time)
    expect(Series.t().toString()).to.be.eql ((d)-> d.time).toString()
    Series.cleanAccessor()
    
    s = new Series()
    s.y((d)-> d.v)
    expect(s.y().toString()).to.be.eql ((d)-> d.v).toString()
    s.t((d)-> d.time)
    expect(s.t().toString()).to.be.eql ((d)-> d.time).toString()

    dat = [0..9].map (d)-> {v: d, t: 100 - d}
    Series.y((d)-> d.v).t((d)-> d.t)
    expect(Series.ys(dat)).to.be.deep.eql [0..9]
    expect(Series.ts(dat)).to.be.deep.eql [100..100 - 9]
      
  describe 'util', ->
    it 'replace null'

