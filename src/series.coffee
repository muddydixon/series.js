module.exports = class Series extends Array
  @_t: (d)-> d
  @_y: (d)-> d
  #
  # ## Accessor
  #
  @t: (accessor)->
    if not accessor?
      return Series._t
    if typeof accessor is 'function'
      Series._t = accessor
    else if typeof accessor is 'string'
      Series._tKey = accessor
      Series._t = (d)-> d[accessor]
    else
      throw new Error 't accessor should be function'
    this
    
  @y: (accessor)->
    if not accessor?
      return Series._y
    if typeof accessor is 'function'
      Series._y = accessor
    else if typeof accessor is 'string'
      Series._yKey = accessor
      Series._y = (d)-> d[accessor]
    else
      throw new Error 'y accessor should be function'
    this
    
  @ts: (data)->
    t = Series.t()
    res = []
    for d in data
      res.push t(d)
    res
    
  @ys: (data)->
    y = Series.y()
    res = []
    for d in data
      res.push y(d)
    res
    
  @cleanAccessor: ()->
    Series._t = (d)-> d
    Series._y = (d)-> d
    this

  #
  # ## Array methods
  #
  @range: (begin, end, step =1)->
    arr = []
    v = start
    while v < end
      arr.push v
      v += step
    arr
  @nest: ()->
    new Series.Nest()
  @zip: (arrs...)->
    zipped = []
    lens = []
    for arr in arrs
      if not arr instanceof Array
        throw new Error 'arrays should be array'
      lens.push arr.length
    maxlen = Math.max.apply Math, lens

    i = 0
    while i < maxlen
      zipped.push zipped, (arr[i] or null for arr in arrs)
    zipped
  @transpose: (data)->
  @nullTo: (data, val)->

  #
  # ## Hash methods
  # 
  @keys: (obj)->
    (k for k of obj)
  @vals: (obj)->
    (v for k, v of obj)
  @entries: (obj)->
    ({key: k, value: v} for k, v of obj)

  #
  # ### statistical methods
  # 
  @lag: (data, lag = 1)->
    y = Series.y()
    Series.cleanAccessor()
    
    len = data.length
    res = [null]
    for i in [0..len - 2]
      res.push y(data[i])
    res
  @sum: Series.sum=(data)->
    y = Series.y()
    Series.cleanAccessor()
    
    len = data.length
    sum = 0
    for i in [0..len - 1]
      sum += y(data[i])
    sum
  @mean: (data)->
    y = Series.y()
    sum = Series.y(y).sum data
    Series.cleanAccessor()
    sum / data.length
  @quantile: (data, p)->
    y = Series.y()
    Series.cleanAccessor()
    unless 0 <= p <= 1.0
      throw new Error "p must in range [0, 1.0] (#{p})"
    
    H = (data.length - 1) * p + 1
    h = Math.floor(H)
    v = +y(data[h - 1])
    e = H - h
    if e? then v + e * (y(data[h]) - v) else v
  @median: (data)->
    Series.quantile(data, 0.5)
  @sumsq: (data)->
    y = Series.y()
    Series.cleanAccessor()
    len = data.length
    sum = 0
    for i in [0..len - 1]
      sum += Math.pow y(data[i]), 2
    sum
  @variance: (data)->
    y = Series.y()
    len = data.length
    mean = Series.mean data
    sum = 0
    for i in [0..len - 1]
      sum += Math.pow(y(data[i]) - mean, 2)
    sum / (len - 1)
  @variancep: (data)->
    len = data.length
    variance = Series.variance(data)
    variance * (len - 1) / len
  @stdev: (data)->
    variance = Series.variance(data)
    Math.sqrt variance
  @stdevp: (data)->
    variance = Series.variancep(data)
    Series.cleanAccessor()
    Math.sqrt variance
  @covariance: (dataA, dataB)->
    y = Series.y()
    meanA = Series.mean dataA
    meanB = Series.y(y).mean dataB
    Series.cleanAccessor()
    len = Math.min dataA.length, dataB.length
    
    sum = 0
    for i in [0..len - 1]
      sum += (y(dataA[i]) - meanA) * (y(dataB[i]) - meanB)
    sum / (len - 1)
  @covariancep: (dataA, dataB)->
    cov = Series.covariance dataA, dataB
    len = Math.min dataA.length, dataB.length
    cov * (len - 1) / len
  @correlation: (dataA, dataB)->
    y = Series.y()
    Series.covariance(dataA, dataB) / (Series.y(y).stdev(dataA) * Series.y(y).stdev(dataB))
  @autocovariance: (data, limit)->
    y = Series.y()
    Series.cleanAccessor()
    len = data.length
    lagmax = Math.min(48, Math.max(10, len / 2))

    res = []
    for lag in [0..lagmax - 1]
      res.push Series.y(y).covariance(
        data.slice(0, len - lag).concat(data.slice(len - lag, len))
        data.slice(lag, len).concat(data.slice(0, lag))
      )
    res
    
  @autocorrelation: (data, limit)->
    y = Series.y()
    Series.cleanAccessor()
    len = data.length
    lagmax = Math.min(48, Math.max(10, len / 2))

    res = []
    for lag in [0..lagmax - 1]
      res.push Series.y(y).correlation(
        data.slice(0, len - lag).concat(data.slice(len - lag, len))
        data.slice(lag, len).concat(data.slice(0, lag))
      )
    res
    
  @spectrum: ()->
  @movingaverage: ()->
  @ar: ()->

  #
  # ## aggregation
  #
  @aggregation: (calc)->
    tKey = Series._tKey or 't'
    yKey = Series._yKey or 'y'
    y = Series.y()
    t = Series.y()
    
    key = Series.t()
    sort = null

    aggr = (data, args...)->

      len = data.length
      
      keyvals = {}
      for i in [0..len - 1]
        k = key(data[i])
        keyvals[k] = [] unless keyvals[k]
        keyvals[k].push data[i]

      aggregated = []
      for k, values of keyvals
        Series.y(y).t(t)
        obj = {}
        obj[tKey] = k
        obj[yKey] = calc values, args
        aggregated.push obj

      if not sort?
        aggregated
      else
        aggregated.sort sort


    aggr.key = (_key)->
      key = _key
      this
    aggr.sort = (_sort)->
      if typeof _sort is 'function'
        sort = _sort
      this
    aggr
  #
  # ## constructor
  #
  constructor: ()->
    @_t = (d)-> d
    @_y = (d)-> d

  #
  # ## Accessor
  #
  t: (accessor)->
    if not accessor?
      return @_t
    if typeof accessor is 'function'
      @_t = accessor
    else if typeof accessor is 'string'
      @_tKey = accessor
      @_t = (d)-> d[accessor]
    else
      throw new Error 't accessor should be function'
    this
    
  y: (accessor)->
    if not accessor?
      return @_y
    if typeof accessor is 'function'
      @_y = accessor
    else if typeof accessor is 'string'
      @_yKey = accessor
      @_y = (d)-> d[accessor]
    else
      throw new Error 'y accessor should be function'
    this
    
  cleanAccessor: ()->
    @_t = (d)-> d
    @_y = (d)-> d
    this
    
  #
  # ## data put
  #
  put: (d)->
    @push d

    # TODO: 移動平均, 移動分散の計算
    if @length > @capsize
      @shift()
    this

  #
  # ## statistical methods
  #
  sum: ()->                     Series.t(@t()).y(@y()).sum this
  mean: ()->                    Series.t(@t()).y(@y()).mean this
  quantile: (p)->               Series.t(@t()).y(@y()).quantile this, p
  median: ()->                  Series.t(@t()).y(@y()).median this
  sumsq: ()->                   Series.t(@t()).y(@y()).sumsq this
  variance: ()->                Series.t(@t()).y(@y()).variance this
  variancep: ()->               Series.t(@t()).y(@y()).variancep this
  stdev: ()->                   Series.t(@t()).y(@y()).stdev this
  stdevp: ()->                  Series.t(@t()).y(@y()).stdevp this
  covariance: (data)->          Series.t(@t()).y(@y()).covariance this, data
  covariancep: (data)->         Series.t(@t()).y(@y()).covariancep this, data
  correlation: (data)->         Series.t(@t()).y(@y()).correlation this, data
  autocovariance: (limit)->     Series.t(@t()).y(@y()).autocovariance this, limit
  autocorrelation: (limit)->    Series.t(@t()).y(@y()).autocorrelation this, limit
  spectrum: ()->                Series.t(@t()).y(@y()).spectrum this
  ar: ()->                      Series.t(@t()).y(@y()).ar this
  movingaverage: ()->           Series.t(@t()).y(@y()).movingaverage this

  aggregation: (calc)->
    Series.y(@y()).aggregation(calc)

#
# ## time format / parse method
#
# Below code is borrowed in [d3.js](https://github.com/mbostock/d3/wiki/Time-Formatting)
#
do (Series)->
  # time
  offset = new Date().getTimezoneOffset() * 60000
  pads = {
    '-': ''
    '_': ' '
    '0': '0'
  }
  formatPad = (value, fill, width)->
    value += ""
    length = value.length
    if length < width then new Array(width - length + 1).join(fill) + value else value

  dayOfYear = (d)->
    y = year(d)
    Math.floor (d - y) / 864e5

  Series.format = (template)->
    n = template.length
    format = (date)->
      string = []
      i = -1
      j = 0
      c = null
      p = null
      f = null

      while ++i < n
        if template.charCodeAt(i) is 37
          string.push template.substring(j, i)
          if (p = pads[c = template.charAt(++i)]) isnt undefined
            c = template.charAt(++i)
          if (f = formats[c])?
            c = f(date, unless p? then (if c is "e" then " " else "0") else p)
          string.push c
          j = i + 1
      string.push template.substring(j, i)
      string.join("")

    # format.parse = (string)->

  formats =
    a: (d)-> [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ][d.getDay()]
    A: (d)-> [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ][d.getDay()]
    b: (d)-> [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ][d.getMonth()]
    B: (d)-> [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ][d.getMonth()]
    c: Series.format("%a %b %e %X %Y")
    d: (d, p)-> formatPad(d.getDate(), p, 2)
    e: (d, p)-> formatPad(d.getDate(), p, 2)
    H: (d, p)-> formatPad(d.getHours(), p, 2)
    I: (d, p)-> formatPad(d.getHours() % 12 || 12, p, 2)
    j: (d, p)-> formatPad(1 + dayOfYear(d), p, 3)
    L: (d, p)-> formatPad(d.getMilliseconds(), p, 3)
    m: (d, p)-> formatPad(d.getMonth() + 1, p, 2)
    M: (d, p)-> formatPad(d.getMinutes(), p, 2)
    p: (d)-> if d.getHours() >= 12 then "PM" else "AM"
    S: (d, p)-> formatPad(d.getSeconds(), p, 2)
    # U: (d, p)-> d3_time_formatPad(d3.time.sundayOfYear(d), p, 2)
    w: (d)-> d.getDay()
    # W: (d, p)-> formatPad(d3.time.mondayOfYear(d), p, 2)
    x: Series.format("%m/%d/%Y")
    X: Series.format("%H:%M:%S")
    y: (d, p)-> formatPad(d.getFullYear() % 100, p, 2)
    Y: (d, p)-> formatPad(d.getFullYear() % 10000, p, 4)
    Z: (d)-> d.getTimezoneOffset(),
    "%": ()-> "%"
    
  normal = (msec)->
    imsec = 1 / msec
    (time)->
      time = time.getTime() if time instanceof Date
      new Date (0|time * imsec) * msec
   
  minute = normal(60000)
  hour   = normal(3600000)
  day    = (time)->
    time = new Date(time) unless time instanceof Date
    new Date(time.getFullYear(), time.getMonth(), time.getDate(), 0, 0, 0)
  week   = (time)->
    time = new Date(time) unless time instanceof Date
    d = time.getDay()
    new Date(time.getFullYear(), time.getMonth(), time.getDate() - d, 0, 0, 0)
  month  = (time)->
    time = new Date(time) unless time instanceof Date
    new Date(time.getFullYear(), time.getMonth(), 1, 0, 0, 0)
  year   = (time)->
    time = new Date(time) unless time instanceof Date
    new Date(time.getFullYear(), 0, 1, 0, 0, 0)

  Series.minute = minute
  Series.hour   = hour
  Series.day    = day
  Series.week   = week
  Series.month  = month
  Series.year   = year

class Series.Nest
  constructor: ()->
    @keys = []
    @sortKeys = []
    @sortValues = []
    
  key: (func)->
    @keys.push func
    this

  sortKey: (sort)->
    depth = @keys.length - 1
    @sortKeys[depth] = sort or (a, b)-> a - b
    this
    
  sortValue: (sort)->
    depth = @keys.length - 1
    @sortValues[depth] = sort or (a, b)-> key(a) - key(b)
    this
    
  _map: (data, depth)->
    key = @keys[depth]

    map = {}
    for d in data
      map[key(d)] = [] unless map[key(d)]
      map[key(d)].push d

    if @keys.length > depth + 1
      for k, v of map
        map[k] = @_map v, depth + 1
    map
    
  map: (data)->
    if not data?
      @logger.warn "no data"
      return null
    if data.length is 0
      @logger.warn "data length is 0"
      return null
      
    @_map data, 0

  _entries: (map, depth)->
    if @keys.length < depth + 1
      return map
    # TODO: calc leavs number
    ({key: k, values: @_entries(v, depth + 1) } for k, v of map)
    
  entries: (data)->
    if not data?
      @logger.warn "no data"
      return null
    if data.length is 0
      @logger.warn "data length is 0"
      return null
      
    map = @_map data, 0
    @_entries map, 0
