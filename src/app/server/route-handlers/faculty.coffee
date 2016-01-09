'use strict'

exports.FacultyRequestHandler = class FacultyRequestHandler
    _frhInstance = undefined

    @getRequestHandler = ->
        _frhInstance ?= new _LocalFacultyRequestHandler

    class _LocalFacultyRequestHandler

        constructor: ->
