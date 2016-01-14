'use strict'

exports.AuthorizationManager = class AuthorizationManager

    _amInstance = undefined

    @getAuthorizationManagerInstance: ->
        _amInstance ?= new _LocalAuthorizationManager

    class _LocalAuthorizationManager

        _checkAuthorization = (userProfile, mthName, callback) ->
            authorizedMethods = @authorizations[userProfile]
            if not authorizedMethods?
                unknownUserProfileError = new Error "User profile #{userProfile} is unknown to authorization system"
                callback unknownUserProfileError, null
            else if not mthName in authorizedMethods
                callback null, false
            else
                callback null, true

        constructor: ->
            @authorizations =
                admin: ['insertAllStudents', 'insertAcademicStructure']

        checkAuthorization: (userProfile, mthName, callback) =>
            _checkAuthorization.call @ userProfile, mthName, (authorizationError, authorizationResult) =>
                callback authorizationError, authorizationResult
