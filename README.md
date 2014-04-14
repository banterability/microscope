microscope
==========

## Config

A `config.json` in the root of the project directory holds all the necessary API keys and config parameters. What exists so far:

| Key | Value |
| --- | ----- |
| `modules.forecast.apiKey` | An API key for [Forecast](https://developer.forecast.io/), available [from The Dark Sky Company](https://developer.forecast.io/register). |
| `modules.googleMaps.apiKey` | An API key for the [Google Maps V3 Javascript API](https://developers.google.com/maps/documentation/javascript/), available [from Google](https://developers.google.com/maps/documentation/javascript/tutorial#api_key). |
| `modules.lastFm.apiKey` | An API key for the [Last.fm API](http://www.last.fm/api), available from [Last.fm](http://www.last.fm/api/account/create). |
| `modules.lastFm.apiSecret` | The associated secret for the above account, which can be found [on your API accounts page](http://www.last.fm/api/accounts). |
| `modules.lastFm.user` | The username you'd like to retrieve tracks from. |
| `location.lat` | The latitude that should be used for location-aware modules (Currently just Forecast). |
