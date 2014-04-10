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
    cb err, presentForecast body

presentForecast = (response) ->
  currentTemp = "#{Math.floor(response.currently.temperature)}°F"
  currentCondtions = response.currently.summary

  today = response.daily.data[0]

  averageChicagoTwilightInSeconds = 60 * 19
  now = new Date()
  dawn = _epochToNativeDate today.sunriseTime - averageChicagoTwilightInSeconds
  sunrise = _epochToNativeDate today.sunriseTime
  sunset = _epochToNativeDate today.sunsetTime
  dusk = _epochToNativeDate today.sunsetTime + averageChicagoTwilightInSeconds

  currentLightConditions = switch
    when now < dawn then 'night'
    when dawn <= now < sunrise then 'dawn'
    when sunrise <= now < sunset then 'day'
    when sunset <= now < dusk then 'dusk'
    when dusk <= now then 'night'
    else throw new Error 'missed edge case!'

  {timeOfDay: currentLightConditions, temperature: currentTemp, conditions: currentCondtions, sunsetTime: sunset}

_epochToNativeDate = (unixTimestamp) ->
  new Date(unixTimestamp * 1000)

module.exports =
  fetch: getForecast
