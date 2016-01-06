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
session        = require 'express-session'
RedisStore     = require('connect-redis')(session)
redisClient    = require('redis').createClient()
EventEmitter = require('events').EventEmitter

ConfigurationManager = require('app/server/lib/config-manager').ConfigurationManager
PoolManager          = require('app/server/lib/pool-manager').PoolManager
QueueManager         = require('app/server/lib/queue-manager').QueueManager

ConfigurationManager.getConfigurationManager().loadConfig (loadError, loadResult) =>
    if loadError?
        console.log "oops! there was an error loading the configurations..."
    else
        # more parameters
        oneDay = 8640000


        # define session options
        owSessionOptions =
            resave: false
            saveUninitialized: true
            secret: 'abdsgfdeweqsdsfasdfgdfs'
            store: new RedisStore({
                    client: redisClient
                })
            cookie: {
                maxAge: new Date(Date.now() + oneDay)
            }


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
        # connect session data to express

        # define folder for static resources and how long they can be cached

        evtEmitter = new EventEmitter

        poolManager = PoolManager.getPoolManagerInstance evtEmitter
        queueManager = QueueManager.getQueueManagerInstance evtEmitter
        poolManager.setExecutionEnvironment app.settings.env

        require('app/server/routes/students')(app, poolManager, queueManager)

        ConfigurationManager.getConfigurationManager().getSSLFileNames app.settings.env, (sslFileNameError, sslFileNames) =>
            if sslFileNameError?
                console.log "There was an error loading the ssl key or cetrtificate..."
                console.log sslFileNameError.message
            else
                # define the security parameters for http2
                securityKeyFileName =
                serverOptions =
                    key: fs.readFileSync __dirname + '/../ssl/' + sslFileNames[0]
                    cert: fs.readFileSync __dirname + '/../ssl/' + sslFileNames[1]
                    requestCert: true
                    passphrase: 'first oweek at nust'

                # create the http2 server and connect it to the express server
                server = http2.createServer serverOptions, app
                portNumber = 5480

                io = require('socket.io').listen server

                server.listen portNumber, () ->
                    console.log "Welcome to orientation week application at nust now running -- server listening on port %d in mode %s", portNumber, app.settings.env
