'use strict'

AbstractController = require('./abstract-controller').AbstractController
LocationModel      = require('../models/location').LocationModel

exports.LocationsController = class LocationsController extends AbstractController

    _getAllLocations = (poolManager, queueManager, callback) ->
        @location.findAll (findError, allLocations) =>
            @release 'locations', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, allLocations

    _getLocation = (locationID, poolManager, queueManager, callback) ->
        @location.findOne locationID, (getLocationError, locationDetails) =>
            @release 'locations', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback getLocationError, locationDetails

    constructor: (envVal) ->
        @location = new LocationModel envVal

    getAllLocations: (poolManager, queueManager, callback) =>
        _getAllLocations.call @, poolManager, queueManager, (allLocationError, allLocations) =>
            callback allLocationError, allLocations

    getLocation: (locationID, callback) =>
        _getLocation.call @, locationID, poolManager, queueManager, (getLocationError, locationDetails) =>
            callback getLocationError, locationDetails
