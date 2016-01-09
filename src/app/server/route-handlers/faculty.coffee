'use strict'

exports.FacultyRequestHandler = class FacultyRequestHandler
    _frhInstance = undefined

    @getRequestHandler = ->
        _frhInstance ?= new _LocalFacultyRequestHandler

    class _LocalFacultyRequestHandler

        _insertAcademicStructure = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'faculties', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    insertAcademicStructureRequestObject =
                        methodName: 'insertAcademicStructure'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'faculties', insertAcademicStructureRequestObject
                else
                    controllerInstance.insertAcademicStructure poolManager, queueManager, (academicStructureCreationError, academicStructureCreationResult) =>
                        if academicStructureCreationError?
                            response.json 500, {error: academicStructureCreationError.message}
                        else
                            response.json 201, academicStructureCreationResult

        constructor: ->

        insertAcademicStructure: (queueManager, poolManager, request, response) =>
            _insertAcademicStructure.call @, queueManager, poolManager, request, response
