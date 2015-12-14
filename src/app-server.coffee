'use strict'

# This is the main class of the app
#
# @author José G. Quenum

# define an execution environment
myEnv = process.env.NODE_ENV || 'development'

# loading required packages
bodyParser     = require 'body-parser'
compress       = require 'compression'
express        = require 'express'
methodOverride = require 'method-override'
morgan         = require 'morgan'
fs             = require 'fs'

# more parameters
oneDay = 8640000

# create the express application
app = express()

# set up view template
app.set 'views', __dirname + '/app/views'
app.engine('html', require('ejs').renderFile)

# express configuration
app.use(compress())
app.use(bodyParser.urlencoded({extended: false}))
app.use(bodyParser.json())
app.use(methodOverride())

# define folder for static resources and how long they can be cached

# define the security parameters for http2
serverOptions =
    key: fs.readFileSync __dirname + '/../ssl/oweek.key'
    cert: fs.readFileSync __dirname + '/../ssl/oweek.crt'
    requestCert: true
    passphrase: 'first oweek at nust'

# create the http2 server and connect it to the express server
server = http2.createServer serverOptions, app
portNumber = 5480

server.listen portNumber, () ->
    console.log "Welcome to orientationb week application at nust now running -- server listening on port %d in mode %s", portNumber, app.settings.env
