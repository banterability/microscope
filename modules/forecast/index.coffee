{timeFromNow} = require './helpers'
ForecastClient = require './client'

getForecast = (config, cb) ->
  {lat, lng} = config.location
  apiKey = config.modules.forecast.apiKey

  Forecast = new ForecastClient {lat, lng, apiKey}

  Forecast.fetch {}, (err, body) ->
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

  {
    timeOfDay: currentLightConditions,
    temperature: currentTemp,
    conditions: currentCondtions,
    sunsetTime: sunset
    sunsetTimeString: timeFromNow(sunset)
  }

_epochToNativeDate = (unixTimestamp) ->
  new Date(unixTimestamp * 1000)


module.exports = {getForecast}