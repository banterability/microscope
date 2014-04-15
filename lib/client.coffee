request = require 'request'
{extend} = require 'underscore'

class ApiClient
  constructor: (@options) ->

  buildUrl: ->
    throw new Error '#buildUrl not implimented'

  defaultOptions: ->
    json: true

  fetch: (options, cb) ->
    requestOptions = extend {}, @defaultOptions(), options, {
      url: @buildUrl()
    }

    console.log '[ApiClient] Fetching with options', requestOptions

    request requestOptions, (err, res, body) ->
      cb err, body

module.exports = ApiClient
