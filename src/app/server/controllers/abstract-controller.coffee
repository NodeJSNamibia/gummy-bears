'use strict'

# This is an abstract controller class

exports.AbstractController = class AbstractController
    _release = (poolManager, queueManager, callback) ->
        poolManager.release 'students', @, queueManager, (releaseError, releaseResult) =>
            callback releaseError, releaseResult

    release: (poolManager, queueManager, callback) =>
        _release.call @, poolManager, queueManager, (releaseError, releaseResult) =>
            callback releaseError, releaseResult
