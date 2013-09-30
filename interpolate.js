var d3 = {};

function d3_interpolateNumber(a, b) {
  b -= a = +a;
  return function(t) { return a + b * t; };
}

d3.interpolators = [
  function(a, b) {
    var t = typeof b;
    return (t === "object" ? d3_interpolateArray : d3_interpolateNumber)(a, b);
  }
];

function d3_interpolate(a, b) {
  var i = d3.interpolators.length, f;
  while (--i >= 0 && !(f = d3.interpolators[i](a, b)));
  return f;
}

function d3_interpolateArray(a, b) {
  var x = [],
      c = [],
      na = a.length,
      nb = b.length,
      n0 = Math.min(a.length, b.length),
      i;
  for (i = 0; i < n0; ++i) x.push(d3_interpolate(a[i], b[i]));
  for (; i < na; ++i) c[i] = a[i];
  for (; i < nb; ++i) c[i] = b[i];
  return function(t) {
    for (i = 0; i < n0; ++i) c[i] = x[i](t);
    return c;
  };
}

var prop = d3_interpolateArray([1,2,3], [1,1,1]);
[0, 1, 2, 3, 4, 5].forEach(function(i){
  console.log(prop(i / 5));
});
