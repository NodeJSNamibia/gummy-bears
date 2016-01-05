'use strict'

# This is an abstract controller class

exports.AbstractController = class AbstractController
    _release = (poolManager, callback) ->
        poolManager.release 'students', @, (releaseError, releaseResult) =>
            callback releaseError, releaseResult

    release: (poolManager, callback) =>
        _release.call @, poolManager, (releaseError, releaseResult) =>
            callback releaseError, releaseResult
