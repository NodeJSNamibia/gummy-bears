'use strict'

CheckAndSanitizationHelper = require('../util/sanitization-helper').CheckAndSanitizationHelper
ConfigurationManager       = require('../lib/config-manager').ConfigurationManager
DataManager                = require('../lib/data-manager').DataManager
validator                  = require('validator')

exports.LocationModel = class LocationModel

    _checkAndSanitizeLocationID = (locationID, callback) ->
        @sanitizationHelper.checkAndSanitizeID locationID, "Error! Null location ID", "Invalid location ID", true, validator, (locationIDError, validLocationID) =>
            callback locationIDError, validLocationID

    _findAll = (callback) ->
        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
            if urlError?
                callback urlError, null
            else
                DataManager.getDBManagerInstance(dbURL).findAllLocations (findAllError, allLocations) =>
                    callback findAllError, allLocations

    _findOne = (locationID, callback) ->
        _checkAndSanitizeLocationID.call @, locationID, (locationIDError, validLocationID) =>
            if locationIDError?
                callback locationIDError, null
            else
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        DataManager.getDBManagerInstance(dbURL).findlocation validLocationID, (findError, findResult) =>
                            callback findError, findResult

    constructor: (@appEnv) ->
        @sanitizationHelper = new CheckAndSanitizationHelper()

    findAll: (callback) =>
        _findAll.call @, (findError, allLocations) =>
            callback findError, allLocations

    findOne: (locationID, callback) =>
        _findOne.call @, locationID, (getLocationError, locationDetails) =>
            callback getLocationError, locationDetails
