'use strict'

cson = require 'cson'
exports.ConfigurationManager = class ConfigurationManager
    _managerInstance = undefined

    @getConfigurationManager: () ->
        _managerInstance ?= new _LocalConfigurationManager

    class _LocalConfigurationManager
        constructor: ->
            @configs = undefined

        loadConfig: (callback) =>
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
