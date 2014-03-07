Series.js [![Build Status](https://travis-ci.org/muddydixon/series.js.png?branch=travis)](https://travis-ci.org/muddydixon/series.js)
-----

Utilitie Library for time series operation.

Calculate data array via `accessor` method.

* Statistics:
  * sum, sumsq
  * mean, median, quantile
  * variance, standard devience, covariance, correlation
  * auto covariance, auto correlation
* Aggregation
  * minute
  * hour
  * day
  * week
  * month
  * year
* Analytics (soon)
  * auto regression
  * spectrum
  * moving average
  * holt-winters

## Usage

### Array Operation

for data array

```
Series.sum([1,2,3,4,5]);  // => 15
Series.mean([1,2,3,4,5]); // => 3
```

for object array

```
Series.y(function(d){ return d.v;})
  .sum([{v:1},{v:2},{v:3},{v:4},{v:5}]);  // => 15
Series.y(function(d){ return d.v;})
  .mean([{v:1},{v:2},{v:3},{v:4},{v:5}]); // => 15
```

### Aggregation

```
var data = [
  {t:1, v:2},{t:1, v:1},{t:2, v:8},
  {t:1, v:4},{t:2, v:3},{t:1, v:2}
];
Series.y(function(d){ return d.v; })
  .aggregation(Series.sum)
  .key(function(d){ return d.t; })
  (data);
// => [{t:1, y:9},{t:2, y:11}]
```

## LICENSE

Apache License Version 2.0
