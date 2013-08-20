expect = require('chai').expect
Series = require '../src/series.coffee'

describe 'series', ->
  describe 'nest', ->
    describe 'class method', ->
      it 'gen Nest', ->
        expect(Series.nest()).to.be.an.instanceof Series.Nest
        expect(new Series.Nest()).to.be.an.instanceof Series.Nest
      
      it 'add keys', ->
        expect(Series.nest().key((d)-> d.x).keys).have.length 1
        expect(Series.nest().key((d)-> d.x).key((d)-> d.y).keys).have.length 2
        
      it 'create nest obj', ->
        data = [0..10].map (d)->
          gender: d % 2
          age: d % 5
          
        expect(Series.nest().key((d)-> d.age)
          .map(data)).to.be.deep.equal {
            0: [
              { gender: 0, age: 0 }
              { gender: 1, age: 0 }
              { gender: 0, age: 0 }
              ]
            1: [
              { gender: 1, age: 1 }
              { gender: 0, age: 1 }
              ]
            2: [
              { gender: 0, age: 2 }
              { gender: 1, age: 2 }
              ]
            3: [
              { gender: 1, age: 3 }
              { gender: 0, age: 3 }
              ]
            4: [
              { gender: 0, age: 4 }
              { gender: 1, age: 4 }
              ]
            }
        expect(Series.nest().key((d)-> d.age).key((d)-> d.gender)
          .map(data)).to.be.deep.equal {
            0: {
              0: [
                { gender: 0, age: 0 }
                { gender: 0, age: 0 }
                ]
              1: [
                { gender: 1, age: 0 }
                ]
              }
            1: {
              1: [
                { gender: 1, age: 1 }
                ]
              0: [
                { gender: 0, age: 1 }
                ]
              }
            2: {
              0: [
                { gender: 0, age: 2 }
                ]
              1: [
                { gender: 1, age: 2 }
                ]
              }
            3: {
              1: [
                { gender: 1, age: 3 }
                ]
              0: [
                { gender: 0, age: 3 }
                ]
              }
            4: {
              0: [
                { gender: 0, age: 4 }
                ]
              1: [
                { gender: 1, age: 4 }
                ]
              }
            }

      # expect(Series.nest().key((d)-> d.age)
      #   .entries(data)).to.be.deep.equal d3.nest().key((d)-> d.age).entries(data)
      # expect(Series.nest().key((d)-> d.age).key((d)-> d.gender)
      #   .entries(data)).to.be.deep.equal d3.nest()
      #     .key((d)-> d.age).key((d)-> d.gender).entries(data)
