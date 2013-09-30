expect = require('chai').expect
Series = require '../src/series.coffee'

describe 'series', ->
  describe 'csv', ->
    samples =
      d3sample:
        csv: 'Hello,World\n42,"""fish"""'
        obj: [{Hello: "42", World: '"fish"'}]
      "return array of object":
        csv: 'a,b,c\n1,2,3\n'
        obj: [{a: "1", b: "2", c: "3"}]
      "return array of object (CRLF)":
        csv: 'a,b,c\r\n1,2,3\r\n'
        obj: [{a: "1", b: "2", c: "3"}]
      "not strip whitespace":
        csv: "a,b,c\n 1, 2,3\n"
        obj: [{a: " 1", b: " 2", c: "3"}]
      "quoted value":
        csv: "a,b,c\n\"1\",2,3"
        obj: [{a: "1", b: "2", c: "3"}]
      "quoted value 2":
        csv: "a,b,c\n\"1\",2,3\n"
        obj: [{a: "1", b: "2", c: "3"}]
      "parses quoted values with quotes":
        csv: "a\n\"\"\"hello\"\"\""
        obj: [{a: "\"hello\""}]
      "parses quoted values with newlines":
        csv: "a\n\"new\nline\""
        obj: [{a: "new\nline"}]
      "parses quoted values with newlines 2":
        csv: "a\n\"new\rline\""
        obj: [{a: "new\rline"}]
      "parses quoted values with newlines 3":
        csv: "a\n\"new\r\nline\""
        obj: [{a: "new\r\nline"}]
      "parses unix newlines":
        csv: "a,b,c\n1,2,3\n4,5,\"6\"\n7,8,9"
        obj: [
          {a: "1", b: "2", c: "3"},
          {a: "4", b: "5", c: "6"},
          {a: "7", b: "8", c: "9"}
        ]
      "parses mac newlines":
        csv: "a,b,c\r1,2,3\r4,5,\"6\"\r7,8,9"
        obj: [
          {a: "1", b: "2", c: "3"},
          {a: "4", b: "5", c: "6"},
          {a: "7", b: "8", c: "9"}
        ]
      "parses dos newlines":
        csv: "a,b,c\r\n1,2,3\r\n4,5,\"6\"\r\n7,8,9"
        obj: [
          {a: "1", b: "2", c: "3"},
          {a: "4", b: "5", c: "6"},
          {a: "7", b: "8", c: "9"}
        ]
      "invokes the row function for every row in order":
        csv: "a\n1\n2\n3\n4"
        func: (d, i)-> d._idx_ = i; d
        obj: [
          {a: "1", _idx_: 0},
          {a: "2", _idx_: 1},
          {a: "3", _idx_: 2},
          {a: "4", _idx_: 3}
        ]

    for testname, data of samples
      do (testname, data)->
        it testname, ->
          expect(Series.csv.parse(data.csv, data.func)).to.deep.equal data.obj
