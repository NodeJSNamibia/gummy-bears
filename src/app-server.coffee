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
