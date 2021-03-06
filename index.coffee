express = require 'express'
fs = require 'fs'
async = require 'async'

{getForecast} = require './modules/forecast'
googleMaps = require './modules/googleMaps'
lastFm = require './modules/lastFm'

config = JSON.parse(fs.readFileSync 'config.json', 'utf-8')

app = express()
app.engine 'mustache', require 'hogan-express'
app.set 'view engine', 'mustache'
app.set 'layout', 'layouts/default'
# app.set 'partials', header: 'partials/_header'

app.get '/', (req, res) ->
  async.parallel {
    weather: (cb) -> getForecast config, cb
    music: (cb) -> lastFm.fetch {config}, cb
  }, (err, results) ->
    context =
      timeOfDay: results.weather.timeOfDay
      weather:
        temperature: results.weather.temperature
        conditions: results.weather.conditions.toLowerCase()
        sunset: results.weather.sunsetTimeString.toLowerCase()
      music:
        playCount: results.music.played.length
        nowPlaying: results.music.nowPlaying

    res.render 'home', context

app.listen 5678
