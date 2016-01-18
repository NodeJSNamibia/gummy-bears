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

    constructor: (envVal) ->
        @location = new LocationModel envVal

    getAllLocations: (poolManager, queueManager, callback) =>
        _getAllLocations.call @, poolManager, queueManager, (allLocationError, allLocations) =>
            callback allLocationError, allLocations
