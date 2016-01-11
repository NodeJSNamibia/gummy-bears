'use strict'

exports.FacultyRequestHandler = class FacultyRequestHandler
    _frhInstance = undefined

    @getRequestHandler = ->
        _frhInstance ?= new _LocalFacultyRequestHandler

    class _LocalFacultyRequestHandler

        _getAllFaculties = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'faculties', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getAllFacultiesRequestObject =
                        methodName: 'getAllFaculties'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'faculties', getAllFacultiesRequestObject
                else
                    controllerInstance.getAllFaculties poolManager, queueManager, (getAllFacultiesError, allFaculties) =>
                        if getAllFacultiesError?
                            response.json 500, {error: getAllFacultiesError.message}
                        else
                            response.json 200, allFaculties

        _getFaculty = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'faculties', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getFacultyRequestObject =
                        methodName: 'getFaculty'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'faculties', getFacultyRequestObject
                else
                    controllerInstance.getFaculty request.params.id, poolManager, queueManager, (facultyError, facultyDetails) =>
                        if facultyError?
                            response.json 500, {error: facultyError.message}
                        else
                            response.json 200, facultyDetails

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

        getAllFaculties: (queueManager, poolManager, request, response) =>
            _getAllFaculties.call @, queueManager, poolManager, request, response

        getFaculty: (queueManager, poolManager, request, response) =>
            _getFaculty.call @, queueManager, poolManager, request, response
