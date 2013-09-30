(function() {
  var Series, d3_dsv, d3_interpolate, d3_interpolateArray, d3_interpolateNumber,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Series = (function(_super) {
    __extends(Series, _super);

    Series._t = function(d) {
      return d;
    };

    Series._y = function(d) {
      return d;
    };

    Series._ys = null;

    Series.t = function(accessor) {
      if (accessor == null) {
        return Series._t;
      }
      if (typeof accessor === 'function') {
        Series._t = accessor;
      } else if (typeof accessor === 'string') {
        Series._tKey = accessor;
        Series._t = function(d) {
          return d[accessor];
        };
      } else {
        throw new Error('t accessor should be function');
      }
      return this;
    };

    Series.y = function(accessor) {
      if (accessor == null) {
        return Series._y;
      }
      if (typeof accessor === 'function') {
        Series._y = accessor;
      } else if (accessor instanceof Array) {
        Series._y = accessor[0];
        Series._ys = accessor;
      } else if (typeof accessor === 'string') {
        Series._yKey = accessor;
        Series._y = function(d) {
          return d[accessor];
        };
      } else {
        throw new Error('y accessor should be function');
      }
      return this;
    };

    Series.ts = function(data) {
      var d, res, t, _i, _len;
      t = Series.t();
      res = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        d = data[_i];
        res.push(t(d));
      }
      return res;
    };

    Series.ys = function(data) {
      var d, res, y, _i, _len;
      y = Series.y();
      res = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        d = data[_i];
        res.push(y(d));
      }
      return res;
    };

    Series.cleanAccessor = function() {
      Series._t = function(d) {
        return d;
      };
      Series._y = function(d) {
        return d;
      };
      Series._ys = null;
      return this;
    };

    Series.range = function(begin, end, step) {
      var arr, v;
      if (step == null) {
        step = 1;
      }
      arr = [];
      v = begin;
      while (v < end) {
        arr.push(v);
        v += step;
      }
      return arr;
    };

    Series.nest = function() {
      return new Series.Nest();
    };

    Series.zip = function() {
      var arr, arrs, i, lens, maxlen, zipped, _i, _len;
      arrs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      zipped = [];
      lens = [];
      for (_i = 0, _len = arrs.length; _i < _len; _i++) {
        arr = arrs[_i];
        if (!arr instanceof Array) {
          throw new Error('arrays should be array');
        }
        lens.push(arr.length);
      }
      maxlen = Math.max.apply(Math, lens);
      i = 0;
      while (i < maxlen) {
        zipped.push(zipped, (function() {
          var _j, _len1, _results;
          _results = [];
          for (_j = 0, _len1 = arrs.length; _j < _len1; _j++) {
            arr = arrs[_j];
            _results.push(arr[i] || null);
          }
          return _results;
        })());
      }
      return zipped;
    };

    Series.transpose = function(data) {};

    Series.nullTo = function(data, val) {};

    Series.keys = function(obj) {
      var k, _results;
      _results = [];
      for (k in obj) {
        _results.push(k);
      }
      return _results;
    };

    Series.vals = function(obj) {
      var k, v, _results;
      _results = [];
      for (k in obj) {
        v = obj[k];
        _results.push(v);
      }
      return _results;
    };

    Series.entries = function(obj) {
      var k, v, _results;
      _results = [];
      for (k in obj) {
        v = obj[k];
        _results.push({
          key: k,
          value: v
        });
      }
      return _results;
    };

    Series.lag = function(data, lag) {
      var i, len, res, y, _i, _ref;
      if (lag == null) {
        lag = 1;
      }
      y = Series.y();
      Series.cleanAccessor();
      len = data.length;
      res = [null];
      for (i = _i = 0, _ref = len - 2; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        res.push(y(data[i]));
      }
      return res;
    };

    Series.sum = Series.sum = function(data) {
      var i, len, sum, y, _i, _ref;
      y = Series.y();
      Series.cleanAccessor();
      len = data.length;
      sum = 0;
      for (i = _i = 0, _ref = len - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        sum += y(data[i]);
      }
      return sum;
    };

    Series.mean = function(data) {
      var sum, y;
      y = Series.y();
      sum = Series.y(y).sum(data);
      Series.cleanAccessor();
      return sum / data.length;
    };

    Series.quantile = function(data, p) {
      var H, e, h, v, y;
      y = Series.y();
      Series.cleanAccessor();
      if (!((0 <= p && p <= 1.0))) {
        throw new Error("p must in range [0, 1.0] (" + p + ")");
      }
      H = (data.length - 1) * p + 1;
      h = Math.floor(H);
      v = +y(data[h - 1]);
      e = H - h;
      if (e != null) {
        return v + e * (y(data[h]) - v);
      } else {
        return v;
      }
    };

    Series.median = function(data) {
      return Series.quantile(data, 0.5);
    };

    Series.sumsq = function(data) {
      var i, len, sum, y, _i, _ref;
      y = Series.y();
      Series.cleanAccessor();
      len = data.length;
      sum = 0;
      for (i = _i = 0, _ref = len - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        sum += Math.pow(y(data[i]), 2);
      }
      return sum;
    };

    Series.variance = function(data) {
      var i, len, mean, sum, y, _i, _ref;
      y = Series.y();
      len = data.length;
      mean = Series.mean(data);
      sum = 0;
      for (i = _i = 0, _ref = len - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        sum += Math.pow(y(data[i]) - mean, 2);
      }
      return sum / (len - 1);
    };

    Series.variancep = function(data) {
      var len, variance;
      len = data.length;
      variance = Series.variance(data);
      return variance * (len - 1) / len;
    };

    Series.stdev = function(data) {
      var variance;
      variance = Series.variance(data);
      return Math.sqrt(variance);
    };

    Series.stdevp = function(data) {
      var variance;
      variance = Series.variancep(data);
      Series.cleanAccessor();
      return Math.sqrt(variance);
    };

    Series.covariance = function(dataA, dataB) {
      var i, len, meanA, meanB, sum, y, _i, _ref;
      y = Series.y();
      meanA = Series.mean(dataA);
      meanB = Series.y(y).mean(dataB);
      Series.cleanAccessor();
      len = Math.min(dataA.length, dataB.length);
      sum = 0;
      for (i = _i = 0, _ref = len - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        sum += (y(dataA[i]) - meanA) * (y(dataB[i]) - meanB);
      }
      return sum / (len - 1);
    };

    Series.covariancep = function(dataA, dataB) {
      var cov, len;
      cov = Series.covariance(dataA, dataB);
      len = Math.min(dataA.length, dataB.length);
      return cov * (len - 1) / len;
    };

    Series.correlation = function(dataA, dataB) {
      var y;
      y = Series.y();
      return Series.covariance(dataA, dataB) / (Series.y(y).stdev(dataA) * Series.y(y).stdev(dataB));
    };

    Series.autocovariance = function(data, limit) {
      var lag, lagmax, len, res, y, _i, _ref;
      y = Series.y();
      Series.cleanAccessor();
      len = data.length;
      lagmax = Math.min(48, Math.max(10, len / 2));
      res = [];
      for (lag = _i = 0, _ref = lagmax - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; lag = 0 <= _ref ? ++_i : --_i) {
        res.push(Series.y(y).covariance(data.slice(0, len - lag).concat(data.slice(len - lag, len)), data.slice(lag, len).concat(data.slice(0, lag))));
      }
      return res;
    };

    Series.autocorrelation = function(data, limit) {
      var lag, lagmax, len, res, y, _i, _ref;
      y = Series.y();
      Series.cleanAccessor();
      len = data.length;
      lagmax = Math.min(48, Math.max(10, len / 2));
      res = [];
      for (lag = _i = 0, _ref = lagmax - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; lag = 0 <= _ref ? ++_i : --_i) {
        res.push(Series.y(y).correlation(data.slice(0, len - lag).concat(data.slice(len - lag, len)), data.slice(lag, len).concat(data.slice(0, lag))));
      }
      return res;
    };

    Series.spectrum = function() {};

    Series.movingaverage = function() {};

    Series.ar = function() {};

    Series.aggregation = function(calc) {
      var aggr, key, sort, t, tKey, y, yKey;
      if (typeof calc === 'function') {
        calc = [calc];
      }
      tKey = Series._tKey || 't';
      yKey = Series._yKey || 'y';
      y = Series.y();
      t = Series.y();
      key = Series.t();
      sort = null;
      aggr = function() {
        var aggregated, args, c, ck, data, i, k, keyvals, len, obj, values, _i, _ref;
        data = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        len = data.length;
        keyvals = {};
        for (i = _i = 0, _ref = len - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          k = key(data[i]);
          if (!keyvals[k]) {
            keyvals[k] = [];
          }
          keyvals[k].push(data[i]);
        }
        aggregated = [];
        for (k in keyvals) {
          values = keyvals[k];
          obj = {};
          obj[tKey] = k;
          if (calc instanceof Array) {
            if (calc.length === 1) {
              Series.y(y).t(t);
              obj[yKey] = calc[0](values, args);
            } else {
              obj[yKey] = calc.map(function(c) {
                Series.y(y).t(t);
                return c(values, args);
              });
            }
          } else {
            for (ck in calc) {
              c = calc[ck];
              Series.y(y).t(t);
              obj[ck] = c(values, args);
            }
          }
          aggregated.push(obj);
        }
        if (sort == null) {
          return aggregated;
        } else {
          return aggregated.sort(sort);
        }
      };
      ['minute', 'hour', 'day', 'week', 'month', 'year'].forEach(function(span) {
        return aggr[span] = function(_t) {
          if (_t) {
            Series.t(_t);
          }
          return aggr.key(Series[span]);
        };
      });
      aggr.key = function(_key) {
        if (typeof _key === 'function') {
          key = _key;
        } else if (typeof _key === 'string') {
          key = function(d) {
            return d[key];
          };
        } else {
          throw new Error('key should be function or attribution');
        }
        return this;
      };
      aggr.sort = function(_sort) {
        if (typeof _sort === 'function') {
          sort = _sort;
        } else {
          throw new Error('key should be function or attribution');
        }
        return this;
      };
      return aggr;
    };

    function Series() {
      this._t = function(d) {
        return d;
      };
      this._y = function(d) {
        return d;
      };
    }

    Series.prototype.t = function(accessor) {
      if (accessor == null) {
        return this._t;
      }
      if (typeof accessor === 'function') {
        this._t = accessor;
      } else if (typeof accessor === 'string') {
        this._tKey = accessor;
        this._t = function(d) {
          return d[accessor];
        };
      } else {
        throw new Error('t accessor should be function');
      }
      return this;
    };

    Series.prototype.y = function(accessor) {
      if (accessor == null) {
        return this._y;
      }
      if (typeof accessor === 'function') {
        this._y = accessor;
      } else if (typeof accessor === 'string') {
        this._yKey = accessor;
        this._y = function(d) {
          return d[accessor];
        };
      } else {
        throw new Error('y accessor should be function');
      }
      return this;
    };

    Series.prototype.cleanAccessor = function() {
      this._t = function(d) {
        return d;
      };
      this._y = function(d) {
        return d;
      };
      return this;
    };

    Series.prototype.put = function(d) {
      this.push(d);
      if (this.length > this.capsize) {
        this.shift();
      }
      return this;
    };

    Series.prototype.sum = function() {
      return Series.t(this.t()).y(this.y()).sum(this);
    };

    Series.prototype.mean = function() {
      return Series.t(this.t()).y(this.y()).mean(this);
    };

    Series.prototype.quantile = function(p) {
      return Series.t(this.t()).y(this.y()).quantile(this, p);
    };

    Series.prototype.median = function() {
      return Series.t(this.t()).y(this.y()).median(this);
    };

    Series.prototype.sumsq = function() {
      return Series.t(this.t()).y(this.y()).sumsq(this);
    };

    Series.prototype.variance = function() {
      return Series.t(this.t()).y(this.y()).variance(this);
    };

    Series.prototype.variancep = function() {
      return Series.t(this.t()).y(this.y()).variancep(this);
    };

    Series.prototype.stdev = function() {
      return Series.t(this.t()).y(this.y()).stdev(this);
    };

    Series.prototype.stdevp = function() {
      return Series.t(this.t()).y(this.y()).stdevp(this);
    };

    Series.prototype.covariance = function(data) {
      return Series.t(this.t()).y(this.y()).covariance(this, data);
    };

    Series.prototype.covariancep = function(data) {
      return Series.t(this.t()).y(this.y()).covariancep(this, data);
    };

    Series.prototype.correlation = function(data) {
      return Series.t(this.t()).y(this.y()).correlation(this, data);
    };

    Series.prototype.autocovariance = function(limit) {
      return Series.t(this.t()).y(this.y()).autocovariance(this, limit);
    };

    Series.prototype.autocorrelation = function(limit) {
      return Series.t(this.t()).y(this.y()).autocorrelation(this, limit);
    };

    Series.prototype.spectrum = function() {
      return Series.t(this.t()).y(this.y()).spectrum(this);
    };

    Series.prototype.ar = function() {
      return Series.t(this.t()).y(this.y()).ar(this);
    };

    Series.prototype.movingaverage = function() {
      return Series.t(this.t()).y(this.y()).movingaverage(this);
    };

    Series.prototype.aggregation = function(calc) {
      return Series.y(this.y()).aggregation(calc);
    };

    return Series;

  })(Array);

  (function(Series) {
    var day, dayOfYear, formatPad, formats, hour, minute, month, offset, pads, week, year;
    offset = new Date().getTimezoneOffset() * 60000;
    pads = {
      '-': '',
      '_': ' ',
      '0': '0'
    };
    formatPad = function(value, fill, width) {
      var length;
      value += "";
      length = value.length;
      if (length < width) {
        return new Array(width - length + 1).join(fill) + value;
      } else {
        return value;
      }
    };
    dayOfYear = function(d) {
      var y;
      y = year(d);
      return Math.floor((d - y) / 864e5);
    };
    Series.format = function(template) {
      var format, n;
      n = template.length;
      return format = function(date) {
        var c, f, i, j, p, string;
        string = [];
        i = -1;
        j = 0;
        c = null;
        p = null;
        f = null;
        while (++i < n) {
          if (template.charCodeAt(i) === 37) {
            string.push(template.substring(j, i));
            if ((p = pads[c = template.charAt(++i)]) !== void 0) {
              c = template.charAt(++i);
            }
            if ((f = formats[c]) != null) {
              c = f(date, p == null ? (c === "e" ? " " : "0") : p);
            }
            string.push(c);
            j = i + 1;
          }
        }
        string.push(template.substring(j, i));
        return string.join("");
      };
    };
    formats = {
      a: function(d) {
        return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][d.getDay()];
      },
      A: function(d) {
        return ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][d.getDay()];
      },
      b: function(d) {
        return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][d.getMonth()];
      },
      B: function(d) {
        return ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][d.getMonth()];
      },
      c: Series.format("%a %b %e %X %Y"),
      d: function(d, p) {
        return formatPad(d.getDate(), p, 2);
      },
      e: function(d, p) {
        return formatPad(d.getDate(), p, 2);
      },
      H: function(d, p) {
        return formatPad(d.getHours(), p, 2);
      },
      I: function(d, p) {
        return formatPad(d.getHours() % 12 || 12, p, 2);
      },
      j: function(d, p) {
        return formatPad(1 + dayOfYear(d), p, 3);
      },
      L: function(d, p) {
        return formatPad(d.getMilliseconds(), p, 3);
      },
      m: function(d, p) {
        return formatPad(d.getMonth() + 1, p, 2);
      },
      M: function(d, p) {
        return formatPad(d.getMinutes(), p, 2);
      },
      p: function(d) {
        if (d.getHours() >= 12) {
          return "PM";
        } else {
          return "AM";
        }
      },
      S: function(d, p) {
        return formatPad(d.getSeconds(), p, 2);
      },
      w: function(d) {
        return d.getDay();
      },
      x: Series.format("%m/%d/%Y"),
      X: Series.format("%H:%M:%S"),
      y: function(d, p) {
        return formatPad(d.getFullYear() % 100, p, 2);
      },
      Y: function(d, p) {
        return formatPad(d.getFullYear() % 10000, p, 4);
      },
      Z: function(d) {
        return d.getTimezoneOffset();
      },
      "%": function() {
        return "%";
      }
    };
    minute = function(time) {
      var t;
      t = Series.t();
      if (!(time instanceof Date)) {
        time = new Date(t(time));
      }
      return new Date(time.getFullYear(), time.getMonth(), time.getDate(), time.getHours(), time.getMinutes(), 0);
    };
    hour = function(time) {
      var t;
      t = Series.t();
      if (!(time instanceof Date)) {
        time = new Date(t(time));
      }
      return new Date(time.getFullYear(), time.getMonth(), time.getDate(), time.getHours(), 0, 0);
    };
    day = function(time) {
      var t;
      t = Series.t();
      if (!(time instanceof Date)) {
        time = new Date(t(time));
      }
      return new Date(time.getFullYear(), time.getMonth(), time.getDate(), 0, 0, 0);
    };
    week = function(time) {
      var d, t;
      t = Series.t();
      if (!(time instanceof Date)) {
        time = new Date(t(time));
      }
      d = time.getDay();
      return new Date(time.getFullYear(), time.getMonth(), time.getDate() - d, 0, 0, 0);
    };
    month = function(time) {
      var t;
      t = Series.t();
      if (!(time instanceof Date)) {
        time = new Date(t(time));
      }
      return new Date(time.getFullYear(), time.getMonth(), 1, 0, 0, 0);
    };
    year = function(time) {
      var t;
      t = Series.t();
      if (!(time instanceof Date)) {
        time = new Date(t(time));
      }
      return new Date(time.getFullYear(), 0, 1, 0, 0, 0);
    };
    Series.minute = minute;
    Series.hour = hour;
    Series.day = day;
    Series.week = week;
    Series.month = month;
    return Series.year = year;
  })(Series);

  Series.Nest = (function() {
    function Nest() {
      this.keys = [];
      this.sortKeys = [];
      this.sortValues = [];
    }

    Nest.prototype.key = function(func) {
      this.keys.push(func);
      return this;
    };

    Nest.prototype.sortKey = function(sort) {
      var depth;
      depth = this.keys.length - 1;
      this.sortKeys[depth] = sort || function(a, b) {
        return a - b;
      };
      return this;
    };

    Nest.prototype.sortValue = function(sort) {
      var depth;
      depth = this.keys.length - 1;
      this.sortValues[depth] = sort || function(a, b) {
        return key(a) - key(b);
      };
      return this;
    };

    Nest.prototype._map = function(data, depth) {
      var d, k, key, map, v, _i, _len;
      key = this.keys[depth];
      map = {};
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        d = data[_i];
        if (!map[key(d)]) {
          map[key(d)] = [];
        }
        map[key(d)].push(d);
      }
      if (this.keys.length > depth + 1) {
        for (k in map) {
          v = map[k];
          map[k] = this._map(v, depth + 1);
        }
      }
      return map;
    };

    Nest.prototype.map = function(data) {
      if (data == null) {
        this.logger.warn("no data");
        return null;
      }
      return this._map(data, 0);
    };

    Nest.prototype._entries = function(map, depth) {
      var k, v, _results;
      if (this.keys.length < depth + 1) {
        return map;
      }
      _results = [];
      for (k in map) {
        v = map[k];
        _results.push({
          key: k,
          values: this._entries(v, depth + 1)
        });
      }
      return _results;
    };

    Nest.prototype.entries = function(data) {
      var map;
      if (data == null) {
        this.logger.warn("no data");
        return null;
      }
      if (data.length === 0) {
        this.logger.warn("data length is 0");
        return null;
      }
      map = this._map(data, 0);
      return this._entries(map, 0);
    };

    return Nest;

  })();

  d3_dsv = function(delimiter, mimeType) {
    var delimiterCode, dsv, formatRow, formatValue, reFormat, response, typedResponse;
    reFormat = new RegExp("[\"" + delimiter + "\n]");
    delimiterCode = delimiter.charCodeAt(0);
    dsv = function(url, row, callback) {
      var xhr;
      if (arguments_.length < 3) {
        callback = row;
        row = null;
      }
      xhr = d3.xhr(url, mimeType, callback);
      xhr.row = function(_) {
        if (arguments_.length) {
          return xhr.response(((row = _) == null ? response : typedResponse(_)));
        } else {
          return row;
        }
      };
      return xhr.row(row);
    };
    response = function(request) {
      return dsv.parse(request.responseText);
    };
    typedResponse = function(f) {
      return function(request) {
        return dsv.parse(request.responseText, f);
      };
    };
    dsv.parse = function(text, f) {
      var o;
      o = void 0;
      return dsv.parseRows(text, function(row, i) {
        var a;
        if (o) {
          return o(row, i - 1);
        }
        a = new Function("d", "return {" + row.map(function(name, i) {
          return JSON.stringify(name) + ": d[" + i + "]";
        }).join(",") + "}");
        o = (f ? function(row, i) {
          return f(a(row), i);
        } : a);
      });
    };
    dsv.parseRows = function(text, f) {
      var EOF, EOL, I, N, a, eol, n, rows, t, token;
      EOL = {};
      EOF = {};
      rows = [];
      N = text.length;
      I = 0;
      n = 0;
      t = void 0;
      eol = void 0;
      token = function() {
        var c, i, j, k;
        if (I >= N) {
          return EOF;
        }
        if (eol) {
          eol = false;
          return EOL;
        }
        j = I;
        if (text.charCodeAt(j) === 34) {
          i = j;
          while (i++ < N) {
            if (text.charCodeAt(i) === 34) {
              if (text.charCodeAt(i + 1) !== 34) {
                break;
              }
              ++i;
            }
          }
          I = i + 2;
          c = text.charCodeAt(i + 1);
          if (c === 13) {
            eol = true;
            if (text.charCodeAt(i + 2) === 10) {
              ++I;
            }
          } else {
            if (c === 10) {
              eol = true;
            }
          }
          return text.substring(j + 1, i).replace(/""/g, "\"");
        }
        while (I < N) {
          c = text.charCodeAt(I++);
          k = 1;
          if (c === 10) {
            eol = true;
          } else if (c === 13) {
            eol = true;
            if (text.charCodeAt(I) === 10) {
              ++I;
              ++k;
            }
          } else {
            if (c !== delimiterCode) {
              continue;
            }
          }
          return text.substring(j, I - k);
        }
        return text.substring(j);
      };
      while ((t = token()) !== EOF) {
        a = [];
        while (t !== EOL && t !== EOF) {
          a.push(t);
          t = token();
        }
        if (f && !(a = f(a, n++))) {
          continue;
        }
        rows.push(a);
      }
      return rows;
    };
    dsv.format = function(rows) {
      var fieldSet, fields;
      if (Array.isArray(rows[0])) {
        return dsv.formatRows(rows);
      }
      fieldSet = new d3_Set;
      fields = [];
      rows.forEach(function(row) {
        var field, _results;
        _results = [];
        for (field in row) {
          if (!fieldSet.has(field)) {
            _results.push(fields.push(fieldSet.add(field)));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
      return [fields.map(formatValue).join(delimiter)].concat(rows.map(function(row) {
        return fields.map(function(field) {
          return formatValue(row[field]);
        }).join(delimiter);
      })).join("\n");
    };
    dsv.formatRows = function(rows) {
      return rows.map(formatRow).join("\n");
    };
    formatRow = function(row) {
      return row.map(formatValue).join(delimiter);
    };
    formatValue = function(text) {
      if (reFormat.test(text)) {
        return "\"" + text.replace(/\"/g, "\"\"") + "\"";
      } else {
        return text;
      }
    };
    return dsv;
  };

  Series.csv = d3_dsv(",", "text/csv");

  Series.tsv = d3_dsv("\t", "text/tab-separated-values");

  d3_interpolateNumber = function(a, b) {
    b -= a = +a;
    return function(t) {
      return a + b * t;
    };
  };

  Series.interpolators = [
    function(a, b) {
      var t;
      t = typeof b;
      return (t === "object" ? d3_interpolateArray : d3_interpolateNumber)(a, b);
    }
  ];

  Series.interpolate = d3_interpolate = function(a, b) {
    var f, i;
    i = Series.interpolators.length;
    f = void 0;
    while (--i >= 0 && !(f = Series.interpolators[i](a, b))) {
      1;
    }
    return f;
  };

  Series.interpolateArray = d3_interpolateArray = function(a, b) {
    var c, i, n0, na, nb, x, _i, _j, _k, _ref, _ref1, _ref2;
    x = [];
    c = [];
    na = a.length;
    nb = b.length;
    n0 = Math.min(a.length, b.length);
    i = void 0;
    for (i = _i = 0, _ref = n0 - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      x.push(d3_interpolate(a[i], b[i]));
    }
    if (n0 < na) {
      for (i = _j = n0, _ref1 = na - 1; n0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = n0 <= _ref1 ? ++_j : --_j) {
        c[i] = a[i];
      }
    }
    if (na < nb) {
      for (i = _k = na, _ref2 = nb - 1; na <= _ref2 ? _k <= _ref2 : _k >= _ref2; i = na <= _ref2 ? ++_k : --_k) {
        c[i] = b[i];
      }
    }
    return function(t) {
      var _l, _ref3;
      for (i = _l = 0, _ref3 = n0 - 1; 0 <= _ref3 ? _l <= _ref3 : _l >= _ref3; i = 0 <= _ref3 ? ++_l : --_l) {
        c[i] = x[i](t);
      }
      return c;
    };
  };

  if (typeof module !== "undefined" && module !== null ? module.exports : void 0) {
    module.exports = Series;
  } else {
    this.Series = Series;
  }

}).call(this);
