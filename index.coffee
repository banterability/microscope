express = require 'express'
fs = require 'fs'
async = require 'async'

forecast = require './modules/forecast'
googleMaps = require './modules/google_maps'
lastFm = require './modules/last_fm'

config = JSON.parse(fs.readFileSync 'config.json', 'utf-8')
app = express()
app.engine 'mustache', require 'hogan-express'
app.set 'view engine', 'mustache'
app.set 'layout', 'layouts/default'
# app.set 'partials', header: 'partials/_header'

location = config.location

prettyTime = (compareDate) ->
  SECOND = 1000
  MINUTE = SECOND * 60
  HOUR = MINUTE * 60
  DAY = HOUR * 24

  now = new Date()
  diff = Math.abs(compareDate - now)
  qualifier = if compareDate > now then 'from now' else 'ago'

  if diff > DAY
    difference = Math.floor(diff / DAY)
    numString = "About #{difference} day #{if difference != 1 then 's' else ''}"
  else if diff > HOUR
    difference = Math.floor(diff / HOUR)
    numString = "About #{difference} hour#{if difference != 1 then 's' else ''}"
  else if diff > MINUTE
    difference = Math.floor(diff / MINUTE)
    numString = "#{difference} minute#{if difference != 1 then 's' else ''}"
  else
    numString = 'Less than a minute'

  "#{numString} #{qualifier}"

app.get '/', (req, res) ->
  async.parallel {
    weather: (cb) -> forecast.fetch {lat: location.lat, lng: location.lng, config}, cb
    music: (cb) -> lastFm.fetch {config}, cb
  }, (err, results) ->
    titleInfo = if results.music.nowPlaying?[0] then "<em>#{results.music.nowPlaying[0].title}</em> by #{results.music.nowPlaying[0].artist}" else 'nothing'

    context =
      timeOfDay: results.weather.timeOfDay
      weather:
        temperature: results.weather.temperature
        conditions: results.weather.conditions.toLowerCase()
        sunset: prettyTime(results.weather.sunsetTime).toLowerCase()
      music:
        playCount: results.music.played.length
        nowPlaying: titleInfo

    res.render 'home', context

app.listen 5678
