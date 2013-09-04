expect = require('chai').expect
Series = require '../src/series.coffee'

describe 'series', ->
  describe 'aggregation', ->
    dat = [0..9].map (d)-> {t: new Date(2013, 0, d + 1), v: d, y: 1, cate: d % 3}
    dat2 = [10..19].map (d)-> {t: new Date(2013, 0, d + 1), v: d, y: 2, cate: d % 3}
    dat3 = []
    [0..1].map (m)->
      [1..new Date(2013, m + 1, 0).getDate()].map (d)->
        [0..23].map (H)->
          [0..59].map (M)->
            [0..9].map (s)->
              dat3.push
                t: new Date(2013, m, d, H, M, 0|Math.random() * 60)
                y: 1
    
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
        Series.cleanAccessor()

        expect(Series.y((d)-> d.v)
          .aggregation([Series.sum, Series.sumsq]).sort((a, b)-> b.t - a.t)
          .key((d)-> d.t.getDay())(dat)).to.be.deep.eql [
            {t: "6", y: [4, 16]}
            {t: "5", y: [3, 9]}
            {t: "4", y: [11, 85]}
            {t: "3", y: [9, 65]}
            {t: "2", y: [7, 49]}
            {t: "1", y: [6, 36]}
            {t: "0", y: [5, 25]}
          ]
        Series.cleanAccessor()

        expect(Series.y((d)-> d.v)
          .aggregation({sum: Series.sum, sumsq: Series.sumsq}).sort((a, b)-> b.t - a.t)
          .key((d)-> d.t.getDay())(dat)).to.be.deep.eql [
            {t: "6", sum: 4, sumsq: 16}
            {t: "5", sum: 3, sumsq: 9}
            {t: "4", sum: 11, sumsq: 85}
            {t: "3", sum: 9, sumsq: 65}
            {t: "2", sum: 7, sumsq: 49}
            {t: "1", sum: 6, sumsq: 36}
            {t: "0", sum: 5, sumsq: 25}
          ]
        Series.cleanAccessor()

      it "time aggregation minute", ->
        for d, i in Series.y((d)-> d.y).aggregation(Series.sum).minute((d)-> d.t)(dat3)
          expect(d).have.property 't', "#{new Date(2013, 0, 1, 0, i)}"
          expect(d).have.property 'y', 10
          
      it "time aggregation hour", ->
        for d, i in Series.y((d)-> d.y).aggregation(Series.mean).hour((d)-> d.t)(dat3)
          expect(d).have.property 't', "#{new Date(2013, 0, 1, i)}"
          expect(d).have.property 'y', 1

      it "time aggregation day", ->
        for d, i in Series.y((d)-> d.y).aggregation(Series.mean).day((d)-> d.t)(dat3)
          expect(d).have.property 't', "#{new Date(2013, 0, i + 1)}"
          expect(d).have.property 'y', 1

      it "time aggregation month", ->
        for d, i in Series.y((d)-> d.y).aggregation(Series.mean).month((d)-> d.t)(dat3)
          expect(d).have.property 't', "#{new Date(2013, i)}"
          expect(d).have.property 'y', 1

      it "time aggregation year", ->
        for d, i in Series.y((d)-> d.y).aggregation(Series.mean).year((d)-> d.t)(dat3)
          expect(d).have.property 't', "#{new Date(2013, 0, 1)}"
          expect(d).have.property 'y', 1

    describe 'instance methods', ->
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

