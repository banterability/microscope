request = require 'request'
{partition} = require 'underscore'

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
    cb err, presentTracks body

presentTracks = (response) ->
  return {nowPlaying: [], played: []} unless response.recenttracks.track?

  [nowPlayingTracks, playedTracks] = partition response.recenttracks.track, (track) -> track['@attr']?.nowplaying is 'true'

  nowPlaying = nowPlayingTracks.map (track) -> presentTrack track
  played = playedTracks.map (track) -> presentTrack track

  {nowPlaying, played}

presentTrack = (track) ->
  title: track.name
  artist: track.artist["#text"]
  album: track.album["#text"]
  images: track.image

module.exports =
  fetch: getTracks
