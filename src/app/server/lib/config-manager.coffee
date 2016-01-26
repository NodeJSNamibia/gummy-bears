'use strict'

cson = require 'cson'

exports.ConfigurationManager = class ConfigurationManager
    _cmInstance = undefined

    @getInstance: ->
        _cmInstance ?= new _LocalConfigurationManager

    class _LocalConfigurationManager

        _getDBConfig = (appEnv, callback) ->
            dbConfig = @configs?[appEnv]["db"]
            if not dbConfig?
                dbConfigError = new Error "No DB configuration for #{appEnv}"
                callback dbConfigError, null
            else
                callback null, dbConfig

        _getSSLConfig = (appEnv, callback) ->
            sslOptions = @configs?[appEnv]["ssl"]
            if not sslOptions?
                sslOptionsError = new Error "Missing SSL details for #{appEnv}"
                callback sslOptionsError, null
            else
                callback null, sslOptions

        _loadConfig = (callback) ->
            configFilePath = __dirname + "/../../public/config.cson"
            parseOptions =
                cson: true
                json: true
                javascript: false
                coffeescript: false
            cson.parseFile configFilePath, parseOptions, (parseError, configObject) =>
                if parseError?
                    callback parseError, null
                else
                    @configs = configObject
                    callback null, null

        constructor: ->
            @configs = undefined

        loadConfig: (callback) =>
            _loadConfig.call @, (loadError, loadResult) =>
                callback loadError, loadResult

        getDBConfig: (appEnv, callback) =>
            _getDBConfig.call @, appEnv, (dbConfigError, dbConfig) =>
                callback dbConfigError, dbConfig

        getSSLConfig: (appEnv, callback) =>
            _getSSLConfig.call @, appEnv, (sslFileNameError, sslFileNames) =>
                callback sslFileNameError, sslFileNames
