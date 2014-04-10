request = require 'request'

BASE_URL = "https://api.forecast.io/forecast"

buildUrl = (options) ->
  "#{BASE_URL}/#{options.apiKey}/#{options.lat},#{options.lng}"

getForecast = (options, cb) ->
  {lat, lng, config} = options

  requestOptions =
    url: buildUrl {lat, lng, apiKey: config.modules.forecast.apiKey}
    qs:
      exclude: 'minutely,hourly,alerts,flags'
    json: true

  request requestOptions, (err, res, body) ->
    cb err, body

module.exports =
  fetch: getForecast
