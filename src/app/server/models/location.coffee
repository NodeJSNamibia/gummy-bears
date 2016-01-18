'use strict'

CheckAndSanitizationHelper = require('../util/sanitization-helper').CheckAndSanitizationHelper
ConfigurationManager       = require('../lib/config-manager').ConfigurationManager
DataManager                = require('../lib/data-manager').DataManager
validator                  = require('validator')

exports.LocationModel = class LocationModel

    _findAll = (callback) ->
        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
            if urlError?
                callback urlError, null
            else
                DataManager.getDBManagerInstance(dbURL).findAllLocations (findAllError, allLocations) =>
                    callback findAllError, allLocations

    constructor: (@appEnv) ->

    findAll: (callback) =>
        _findAll.call @, (findError, allLocations) =>
            callback findError, allLocations
