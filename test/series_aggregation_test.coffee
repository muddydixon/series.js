expect = require('chai').expect
Series = require '../src/series.coffee'

describe 'series', ->
  describe 'aggregation', ->
    dat = [0..9].map (d)-> {t: new Date(2013, 0, d + 1), v: d, y: 1, cate: d % 3}
    dat2 = [10..19].map (d)-> {t: new Date(2013, 0, d + 1), v: d, y: 2, cate: d % 3}
    
    describe 'class methods', ->
      before ->
        Series.cleanAccessor()
        
      it 'with key', ->
        expect(Series.y((d)-> d.v)
          .aggregation(Series.sum)
          .key((d)-> d.t.getDay())(dat)).to.be.deep.eql [
            {t: "0", y: 5}
            {t: "1", y: 6}
            {t: "2", y: 7}
            {t: "3", y: 9}
            {t: "4", y: 11}
            {t: "5", y: 3}
            {t: "6", y: 4}
          ]
          
        expect(Series.y((d)-> d.v)
          .aggregation(Series.sum).sort((a, b)-> b.t - a.t)
          .key((d)-> d.t.getDay())(dat)).to.be.deep.eql [
            {t: "6", y: 4}
            {t: "5", y: 3}
            {t: "4", y: 11}
            {t: "3", y: 9}
            {t: "2", y: 7}
            {t: "1", y: 6}
            {t: "0", y: 5}
          ]

    describe 'class methods', ->
      before ->
        Series.cleanAccessor()
        
      it 'with key', ->
        s = new Series().y((d)-> d.v)
        s.put d for d in dat
        expect(s.aggregation(Series.sum)
          .key((d)-> d.t.getDay())(dat)).to.be.deep.eql [
            {t: "0", y: 5}
            {t: "1", y: 6}
            {t: "2", y: 7}
            {t: "3", y: 9}
            {t: "4", y: 11}
            {t: "5", y: 3}
            {t: "6", y: 4}
          ]
          
        expect(s.aggregation(Series.sum)
          .sort((a, b)-> b.t - a.t)
          .key((d)-> d.t.getDay())(dat)).to.be.deep.eql [
            {t: "6", y: 4}
            {t: "5", y: 3}
            {t: "4", y: 11}
            {t: "3", y: 9}
            {t: "2", y: 7}
            {t: "1", y: 6}
            {t: "0", y: 5}
          ]

