request = require 'request'
{find, include} = require 'underscore'


getLocation = (options, cb) ->
  {lat, lng, config} = options

  requestOptions =
    url: "https://maps.googleapis.com/maps/api/geocode/json"
    qs:
      sensor: true
      latlng: "#{lat},#{lng}"
      key: config.modules.googleMaps.apiKey
    json: true

  request requestOptions, (err, res, body) ->
    cb err, presentLocation body

presentLocation = (response) ->
  neighborhood = find response.results[0]?.address_components, (component) ->
    include component.types, 'neighborhood'
  city = find response.results[0]?.address_components, (component) ->
    include component.types, 'locality'

  if neighborhood and city
    "in #{neighborhood.long_name}, #{city.long_name}"
  else if city
    "in #{city.long_name}"
  else
    "somewhere off the grid"


module.exports =
  fetch: getLocation
