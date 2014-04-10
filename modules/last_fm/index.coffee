request = require 'request'

getDateRangeForDay = (date = new Date()) ->
  year = date.getFullYear()
  month = date.getMonth()
  day = date.getDate()

  start = +(new Date(year, month, day)) / 1000
  end = +(new Date(year, month, day, 23, 59, 59)) / 1000

  [start, end]

getTracks = (options, cb) ->
  {user, date, config} = options

  [startTs, endTs] = getDateRangeForDay date

  requestOptions =
    url: "http://ws.audioscrobbler.com/2.0/"
    qs:
      method: 'user.getRecentTracks'
      user: user
      api_key: config.modules['last.fm'].apiKey
      format: 'json'
      from: startTs
      to: endTs
      limit: 200
    json: true
    headers:
      'User-Agent': 'datadash dev 0.0.1'

  request requestOptions, (err, res, body) ->
    cb err, body

module.exports =
  fetch: getTracks
