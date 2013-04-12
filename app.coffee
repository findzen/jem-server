restify = require 'restify'
bunyan = require 'bunyan'

log = bunyan.createLogger 
  name: 'jem'
  streams: [
    {
      stream: process.stdout
      level: 'debug'
    }
    {
      path: 'app.log'
      level: 'info'
    }
  ]

server = restify.createServer
  name: 'jem'
  log: log

server.use restify.queryParser()

server.get path: '/', (req, res, next) ->
  if req.params.json
    try
      data = JSON.parse req.params.json
    catch e
      res.send error: 
        name: e.name
        message: e.message

    req.log.info data
    res.send 200
  else
    res.send error: 'No data received'

  next()

server.listen 3000, ->
  log.debug '%s listening at <%s>', server.name, server.url