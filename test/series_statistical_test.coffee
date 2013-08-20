expect = require('chai').expect
Series = require '../src/series.coffee'

describe 'series', ->
  describe 'statistical methods', ->
    describe 'class methods', ->
      it 'no accessor', ->
        dat = [0..9]
        dat2 = [10..19]

        expect(Series.lag dat).to.be.deep.eql [null, 0, 1, 2, 3, 4, 5, 6, 7, 8]
        expect(Series.sum dat).to.be.eql 45
        expect(Series.mean dat).to.be.eql 4.5
        expect(Series.quantile dat, 0.25).to.be.eql 2.25
        expect(Series.median dat).to.be.eql 4.5
        expect(Series.sumsq dat).to.be.eql 285
        expect(Series.variance dat).to.be.eql 9.166666666666666
        expect(Series.variancep dat).to.be.eql 8.25
        expect(Series.stdev dat).to.be.eql 3.0276503540974917
        expect(Series.stdevp dat).to.be.eql 2.8722813232690143
        expect(Series.covariance dat, dat2).to.be.eql 9.166666666666666
        expect(Series.covariancep dat, dat2).to.be.eql 8.25
        expect(Series.correlation dat, dat2).to.be.eql 0.9999999999999998
        expect(Series.autocovariance(dat)).to.be.deep.eql [
          9.166666666666666, 4.166666666666667, 0.2777777777777778
          -2.5, -4.166666666666667, -4.722222222222222, -4.166666666666667
          -2.5, 0.2777777777777778, 4.166666666666667 ]
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.autocorrelation(dat)).to.be.deep.eql [
          0.9999999999999998, 0.45454545454545453, 0.0303030303030303,
          -0.2727272727272727, -0.45454545454545453, -0.5151515151515151,
          -0.45454545454545453, -0.2727272727272727, 0.0303030303030303,
          0.45454545454545453 ]
        expect(Series.y()(1)).to.be.eql 1


      it 'with accessor', ->
        dat = [0..9].map (d)-> {v: d}
        dat2 = [10..19].map (d)-> {v: d}

        expect(Series.y((d)-> d.v).lag dat).to.be.deep.eql [null, 0, 1, 2, 3, 4, 5, 6, 7, 8]
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).sum dat).to.be.eql 45
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).mean dat).to.be.eql 4.5
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).quantile dat, 0.25).to.be.eql 2.25
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).median dat).to.be.eql 4.5
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).sumsq dat).to.be.eql 285
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).variance dat).to.be.eql 9.166666666666666
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).variancep dat).to.be.eql 8.25
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).stdev dat).to.be.eql 3.0276503540974917
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).stdevp dat).to.be.eql 2.8722813232690143
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).covariance dat, dat2).to.be.eql 9.166666666666666
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).covariancep dat, dat2).to.be.eql 8.25
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).correlation dat, dat2).to.be.eql 0.9999999999999998
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).autocovariance(dat)).to.be.deep.eql [
          9.166666666666666, 4.166666666666667, 0.2777777777777778
          -2.5, -4.166666666666667, -4.722222222222222, -4.166666666666667
          -2.5, 0.2777777777777778, 4.166666666666667 ]
        expect(Series.y()(1)).to.be.eql 1
        expect(Series.y((d)-> d.v).autocorrelation(dat)).to.be.deep.eql [
          0.9999999999999998, 0.45454545454545453, 0.0303030303030303,
          -0.2727272727272727, -0.45454545454545453, -0.5151515151515151,
          -0.45454545454545453, -0.2727272727272727, 0.0303030303030303,
          0.45454545454545453 ]
        expect(Series.y()(1)).to.be.eql 1
        
    describe 'class methods', ->
      before ()->
        Series.cleanAccessor()

      it 'no accessor', ->
        
        dat = [0..9]
        dat2 = [10..19]
        s = new Series()
        s.put d for d in dat

        expect(s.sum()).to.be.eql 45
        expect(s.mean()).to.be.eql 4.5
        expect(s.quantile 0.25).to.be.eql 2.25
        expect(s.median()).to.be.eql 4.5
        expect(s.sumsq()).to.be.eql 285
        expect(s.variance()).to.be.eql 9.166666666666666
        expect(s.variancep()).to.be.eql 8.25
        expect(s.stdev()).to.be.eql 3.0276503540974917
        expect(s.stdevp()).to.be.eql 2.8722813232690143
        expect(s.covariance dat2).to.be.eql 9.166666666666666
        expect(s.covariancep dat2).to.be.eql 8.25
        expect(s.correlation dat2).to.be.eql 0.9999999999999998
        expect(s.autocovariance()).to.be.deep.eql [
          9.166666666666666, 4.166666666666667, 0.2777777777777778
          -2.5, -4.166666666666667, -4.722222222222222, -4.166666666666667
          -2.5, 0.2777777777777778, 4.166666666666667 ]
        expect(s.autocorrelation()).to.be.deep.eql [
          0.9999999999999998, 0.45454545454545453, 0.0303030303030303,
          -0.2727272727272727, -0.45454545454545453, -0.5151515151515151,
          -0.45454545454545453, -0.2727272727272727, 0.0303030303030303,
          0.45454545454545453 ]
        
      it 'with accessor', ->
        
        dat = [0..9].map (d)-> {v: d}
        dat2 = [10..19].map (d)-> {v: d}
        s = new Series().y((d)-> d.v)
        s.put d for d in dat

        expect(s.sum()).to.be.eql 45
        expect(s.mean()).to.be.eql 4.5
        expect(s.quantile 0.25).to.be.eql 2.25
        expect(s.median()).to.be.eql 4.5
        expect(s.sumsq()).to.be.eql 285
        expect(s.variance()).to.be.eql 9.166666666666666
        expect(s.variancep()).to.be.eql 8.25
        expect(s.stdev()).to.be.eql 3.0276503540974917
        expect(s.stdevp()).to.be.eql 2.8722813232690143
        expect(s.covariance dat2).to.be.eql 9.166666666666666
        expect(s.covariancep dat2).to.be.eql 8.25
        expect(s.correlation dat2).to.be.eql 0.9999999999999998
        expect(s.autocovariance()).to.be.deep.eql [
          9.166666666666666, 4.166666666666667, 0.2777777777777778
          -2.5, -4.166666666666667, -4.722222222222222, -4.166666666666667
          -2.5, 0.2777777777777778, 4.166666666666667 ]
        expect(s.autocorrelation()).to.be.deep.eql [
          0.9999999999999998, 0.45454545454545453, 0.0303030303030303,
          -0.2727272727272727, -0.45454545454545453, -0.5151515151515151,
          -0.45454545454545453, -0.2727272727272727, 0.0303030303030303,
          0.45454545454545453 ]
