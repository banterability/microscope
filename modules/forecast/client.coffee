{extend} = require 'underscore'
ApiClient = require '../../lib/client'


class ForecastClient extends ApiClient

  BASE_URL: "https://api.forecast.io/forecast"

  buildUrl: ->
    {lat, lng, apiKey} = @options
    "#{@BASE_URL}/#{apiKey}/#{lat},#{lng}"

  defaultOptions: ->
    extend super,
      qs:
        exclude: 'minutely,hourly,alerts,flags'


module.exports = ForecastClient
