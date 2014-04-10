timeFromNow = (compareDate) ->
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

module.exports = {timeFromNow}
