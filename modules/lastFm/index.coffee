request = require 'request'
{partition} = require 'underscore'

{getDateRangeForDay} = require './helpers'


getTracks = (options, cb) ->
  {user, date, config} = options

  user = user || config.modules.lastFm.user

  [startTs, endTs] = getDateRangeForDay date

  requestOptions =
    url: "http://ws.audioscrobbler.com/2.0/"
    qs:
      method: 'user.getRecentTracks'
      user: user
      api_key: config.modules.lastFm.apiKey
      format: 'json'
      from: startTs
      to: endTs
      limit: 200
    json: true
    headers:
      'User-Agent': 'datadash dev 0.0.1'

  request requestOptions, (err, res, body) ->
    console.log body
    cb err, presentTracks body

presentTracks = (response) ->
  return {nowPlaying: 'nothing', played: []} unless response.recenttracks.track?

  [nowPlayingTracks, playedTracks] = partition response.recenttracks.track, (track) -> track['@attr']?.nowplaying is 'true'

  nowPlaying = nowPlayingTracks.map (track) -> presentTrack track
  played = playedTracks.map (track) -> presentTrack track

  nowPlayingMessage = if nowPlaying?[0] then "<em>#{nowPlaying[0].title}</em> by #{nowPlaying[0].artist}" else 'nothing'
  console.log 'message', nowPlayingMessage

  {played, nowPlaying: nowPlayingMessage}

presentTrack = (track) ->
  title: track.name
  artist: track.artist["#text"]
  album: track.album["#text"]
  images: track.image


module.exports =
  fetch: getTracks
