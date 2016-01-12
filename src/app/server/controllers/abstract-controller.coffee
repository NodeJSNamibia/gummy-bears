'use strict'

# This is an abstract controller class

exports.AbstractController = class AbstractController
    _release = (controllerFamilyName, poolManager, queueManager, callback) ->
        poolManager.release controllerFamilyName, @, queueManager, (releaseError, releaseResult) =>
            callback releaseError, releaseResult

    release: (controllerFamilyName, poolManager, queueManager, callback) =>
        _release.call @, controllerFamilyName, poolManager, queueManager, (releaseError, releaseResult) =>
            callback releaseError, releaseResult
