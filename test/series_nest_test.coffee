expect = require('chai').expect
Series = require '../src/series.coffee'

describe 'series', ->
  describe 'nest', ->
    describe 'class method', ->
      it 'create instance', ->
        expect(Series.nest()).to.be.an.instanceof Series.Nest
        expect(new Series.Nest()).to.be.an.instanceof Series.Nest

    describe 'instance method', ->
      describe 'add keys', ->
        it 'function', ->
          expect(Series.nest().key((d)-> d.x).keys).have.length 1
          expect(Series.nest().key((d)-> d.x).key((d)-> d.y).keys).have.length 2
        it 'value', ->
          nest = Series.nest().key("x")
          expect(nest.keys).have.length 1
        it 'values', ->
          nest = Series.nest().key("x").key("y")
          expect(nest.keys).have.length 2

      describe 'return map', ->
        data = [0..10].map (d)->
          gender: d % 2
          age: d % 5

        it 'age accessor', ->
          nest = Series.nest().key((d)-> d.age)
          expect(nest.map(data)).to.be.deep.equal {
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
        it 'age value', ->
          nest = Series.nest().key("age")
          expect(nest.map(data)).to.be.deep.equal {
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
        it 'age and gender accessor', ->
          nest = Series.nest().key((d)-> d.age).key((d)-> d.gender)
          expect(nest.map(data)).to.be.deep.equal {
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
        it 'age and gender values', ->
          nest = Series.nest().key("age").key("gender")
          expect(nest.map(data)).to.be.deep.equal {
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
        it 'age accessor and sort values', ->
          nest = Series.nest().key((d)-> d.age).sortValues((a, b)-> b.gender - a.gender)
          expect(nest.map(data)).to.be.deep.eql {
            4: [
              { gender: 1, age: 4 }
              { gender: 0, age: 4 }
              ]
            3: [
              { gender: 1, age: 3 }
              { gender: 0, age: 3 }
              ]
            2: [
              { gender: 1, age: 2 }
              { gender: 0, age: 2 }
              ]
            1: [
              { gender: 1, age: 1 }
              { gender: 0, age: 1 }
              ]
            0: [
              { gender: 1, age: 0 }
              { gender: 0, age: 0 }
              { gender: 0, age: 0 }
              ]
            }
      describe 'return entries', ->
        data = [0..10].map (d)->
          gender: d % 2
          age: d % 5

        it 'age accessor', ->
          nest = Series.nest().key((d)-> d.age)
          expect(nest.entries(data)).to.be.deep.equal [
            {key: '0', values: [
              { gender: 0, age: 0 }
              { gender: 1, age: 0 }
              { gender: 0, age: 0 }
              ]}
            {key: '1', values: [
              { gender: 1, age: 1 }
              { gender: 0, age: 1 }
              ]}
            {key: '2', values: [
              { gender: 0, age: 2 }
              { gender: 1, age: 2 }
              ]}
            {key: '3', values: [
              { gender: 1, age: 3 }
              { gender: 0, age: 3 }
              ]}
            {key: '4', values: [
              { gender: 0, age: 4 }
              { gender: 1, age: 4 }
              ]}
            ]
        it 'age value', ->
          nest = Series.nest().key("age")
          expect(nest.entries(data)).to.be.deep.equal [
            {key: '0', values: [
              { gender: 0, age: 0 }
              { gender: 1, age: 0 }
              { gender: 0, age: 0 }
              ]}
            {key: '1', values: [
              { gender: 1, age: 1 }
              { gender: 0, age: 1 }
              ]}
            {key: '2', values: [
              { gender: 0, age: 2 }
              { gender: 1, age: 2 }
              ]}
            {key: '3', values: [
              { gender: 1, age: 3 }
              { gender: 0, age: 3 }
              ]}
            {key: '4', values: [
              { gender: 0, age: 4 }
              { gender: 1, age: 4 }
              ]}
            ]
        it 'age and gender accessor', ->
          nest = Series.nest().key((d)-> d.age).key((d)-> d.gender)
          expect(nest.entries(data)).to.be.deep.equal [
            {key: '0', values: [
              {key: '0', values: [
                { gender: 0, age: 0 }
                { gender: 0, age: 0 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 0 }
                ]}
              ]}
            {key: '1', values: [
              {key: '0', values: [
                { gender: 0, age: 1 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 1 }
                ]}
              ]}
            {key: '2', values: [
              {key: '0', values: [
                { gender: 0, age: 2 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 2 }
                ]}
              ]}
            {key: '3', values: [
              {key: '0', values: [
                { gender: 0, age: 3 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 3 }
                ]}
              ]}
            {key: '4', values: [
              {key: '0', values: [
                { gender: 0, age: 4 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 4 }
                ]}
              ]}
            ]
        it 'age and gender values', ->
          nest = Series.nest().key("age").key("gender")
          expect(nest.entries(data)).to.be.deep.equal [
            {key: '0', values: [
              {key: '0', values: [
                { gender: 0, age: 0 }
                { gender: 0, age: 0 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 0 }
                ]}
              ]}
            {key: '1', values: [
              {key: '0', values: [
                { gender: 0, age: 1 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 1 }
                ]}
              ]}
            {key: '2', values: [
              {key: '0', values: [
                { gender: 0, age: 2 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 2 }
                ]}
              ]}
            {key: '3', values: [
              {key: '0', values: [
                { gender: 0, age: 3 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 3 }
                ]}
              ]}
            {key: '4', values: [
              {key: '0', values: [
                { gender: 0, age: 4 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 4 }
                ]}
              ]}
            ]
        it 'age accessor and sort keys', ->
          nest = Series.nest().key((d)-> d.age).sortKeys((a, b)-> b - a)
          expect(nest.entries(data)).to.be.deep.eql [
            {key: '4', values: [
              { gender: 0, age: 4 }
              { gender: 1, age: 4 }
              ]}
            {key: '3', values: [
              { gender: 1, age: 3 }
              { gender: 0, age: 3 }
              ]}
            {key: '2', values: [
              { gender: 0, age: 2 }
              { gender: 1, age: 2 }
              ]}
            {key: '1', values: [
              { gender: 1, age: 1 }
              { gender: 0, age: 1 }
              ]}
            {key: '0', values: [
              { gender: 0, age: 0 }
              { gender: 1, age: 0 }
              { gender: 0, age: 0 }
              ]}
            ]

        it 'age and gender accessor sort keys', ->
          nest = Series.nest().key((d)-> d.age).sortKeys((a, b)-> b - a).key((d)-> d.gender)
          expect(nest.entries(data)).to.be.deep.equal [
            {key: '4', values: [
              {key: '0', values: [
                { gender: 0, age: 4 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 4 }
                ]}
              ]}
            {key: '3', values: [
              {key: '0', values: [
                { gender: 0, age: 3 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 3 }
                ]}
              ]}
            {key: '2', values: [
              {key: '0', values: [
                { gender: 0, age: 2 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 2 }
                ]}
              ]}
            {key: '1', values: [
              {key: '0', values: [
                { gender: 0, age: 1 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 1 }
                ]}
              ]}
            {key: '0', values: [
              {key: '0', values: [
                { gender: 0, age: 0 }
                { gender: 0, age: 0 }
                ]}
              {key: '1', values: [
                { gender: 1, age: 0 }
                ]}
              ]}
            ]

        it 'age and gender accessor sort keys', ->
          nest = Series.nest()
            .key((d)-> d.age).sortKeys((a, b)-> b - a)
            .key((d)-> d.gender).sortKeys((a, b)-> b - a)
          expect(nest.entries(data)).to.be.deep.equal [
            {key: '4', values: [
              {key: '1', values: [
                { gender: 1, age: 4 }
                ]}
              {key: '0', values: [
                { gender: 0, age: 4 }
                ]}
              ]}
            {key: '3', values: [
              {key: '1', values: [
                { gender: 1, age: 3 }
                ]}
              {key: '0', values: [
                { gender: 0, age: 3 }
                ]}
              ]}
            {key: '2', values: [
              {key: '1', values: [
                { gender: 1, age: 2 }
                ]}
              {key: '0', values: [
                { gender: 0, age: 2 }
                ]}
              ]}
            {key: '1', values: [
              {key: '1', values: [
                { gender: 1, age: 1 }
                ]}
              {key: '0', values: [
                { gender: 0, age: 1 }
                ]}
              ]}
            {key: '0', values: [
              {key: '1', values: [
                { gender: 1, age: 0 }
                ]}
              {key: '0', values: [
                { gender: 0, age: 0 }
                { gender: 0, age: 0 }
                ]}
              ]}
            ]

        it 'age accessor and sort keys', ->
          nest = Series.nest().key((d)-> d.age).sortKeys((a, b)-> b - a)
          expect(nest.entries(data)).to.be.deep.eql [
            {key: '4', values: [
              { gender: 0, age: 4 }
              { gender: 1, age: 4 }
              ]}
            {key: '3', values: [
              { gender: 1, age: 3 }
              { gender: 0, age: 3 }
              ]}
            {key: '2', values: [
              { gender: 0, age: 2 }
              { gender: 1, age: 2 }
              ]}
            {key: '1', values: [
              { gender: 1, age: 1 }
              { gender: 0, age: 1 }
              ]}
            {key: '0', values: [
              { gender: 0, age: 0 }
              { gender: 1, age: 0 }
              { gender: 0, age: 0 }
              ]}
            ]
        it 'age accessor and sort values', ->
          nest = Series.nest().key((d)-> d.age).sortValues((a, b)-> b.gender - a.gender)
          expect(nest.entries(data)).to.be.deep.eql [
            {key: '0', values: [
              { gender: 1, age: 0 }
              { gender: 0, age: 0 }
              { gender: 0, age: 0 }
              ]}
            {key: '1', values: [
              { gender: 1, age: 1 }
              { gender: 0, age: 1 }
              ]}
            {key: '2', values: [
              { gender: 1, age: 2 }
              { gender: 0, age: 2 }
              ]}
            {key: '3', values: [
              { gender: 1, age: 3 }
              { gender: 0, age: 3 }
              ]}
            {key: '4', values: [
              { gender: 1, age: 4 }
              { gender: 0, age: 4 }
              ]}
            ]
