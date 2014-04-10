getDateRangeForDay = (date = new Date()) ->
  year = date.getFullYear()
  month = date.getMonth()
  day = date.getDate()

  start = +(new Date(year, month, day)) / 1000
  end = +(new Date(year, month, day, 23, 59, 59)) / 1000

  [start, end]


module.exports = {getDateRangeForDay}
