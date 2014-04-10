express = require 'express'

app = express()
app.engine 'mustache', require 'hogan-express'
app.set 'view engine', 'mustache'
app.set 'layout', 'layouts/default'

app.listen 5678
