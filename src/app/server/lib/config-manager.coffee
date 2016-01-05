'use strict'

cson = require 'cson'

exports.ConfigurationManager = class ConfigurationManager
    _managerInstance = undefined

    @getConfigurationManager: ->
        _managerInstance ?= new _LocalConfigurationManager

    class _LocalConfigurationManager
        _getDBURL = (appEnv, callback) ->
            dbURL = @configs?[appEnv]["dbURL"]
            if not dbURL?
                urlError = new Error "No DB URL configuration"
                callback urlError, null
            else
                callback null, dbURL

        _getSSLFileNames = (appEnv, callback) ->
            sslFileNames = []
            keyFileName = @configs?[appEnv]["sslKey"]
            certFileName = @configs?[appEnv]["sslCert"]
            if not keyFileName?
                keyFileNameError = new Error "Missing SSL key file name for #{appEnv}"
                callback keyFileNameError, null
            else
                if not certFileName?
                    certFileNameError = new Error "Missing SSL certificate file name for #{appEnv}"
                    callback certFileNameError, null
                else
                    sslFileNames.push keyFileName
                    sslFileNames.push certFileName
                    callback null, sslFileNames

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

        getDBURL: (appEnv, callback) =>
            _getDBURL.call @, appEnv, (dbURLError, dbURL) =>
                callback dbURLError, dbURL

        getSSLFileNames: (appEnv, callback) =>
            _getSSLFileNames.call @, appEnv, (sslFileNameError, sslFileNames) =>
                callback sslFileNameError, sslFileNames
