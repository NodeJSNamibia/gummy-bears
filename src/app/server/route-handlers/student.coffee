'use strict'

PoolManager = require('../lib/pool-manager').PoolManager

exports.StudentRequestHandler = class StudentRequestHandler
    _srhInstance = undefined

    @getRequestHandler: ->
        _srhInstance ?= new _LocalStudentRequestHandler

    class _LocalStudentRequestHandler

        _authenticate = (queueManager, request, response) ->
            @poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    authenticationRequestObject =
                        methodName: 'authenticate'
                        arguments: [queueManager, request, response]
                    queueManager.enqueueRequest 'students', authenticationRequestObject
                else
                    controllerInstance.authenticate request.body, @poolManager, (authenticationError, authenticationResult) =>
                        if authenticationError?
                            response.json 500, {error: authenticationError.message}
                        else
                            response.json authenticationResult

        _createPassword = (queueManager, request, response) ->
            @poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    createPasswordRequestObject =
                        methodName: 'createPassword'
                        arguments: [queueManager, request, response]
                    queueManager.enqueueRequest 'students', createPasswordRequestObject
                else
                    controllerInstance.createPassword request.params.id, request.body, @poolManager, (passwordCreationError, passwordCreationResult) =>
                        if passwordCreationError?
                            response.json 500, {error: passwordCreationError.message}
                        else
                            response.json 200, passwordCreationResult

        _getAllStudents = (queueManager, request, response) ->
            @poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getAllStudentsRequestObject =
                        methodName: 'getAllStudents'
                        arguments: [queueManager, request, response]
                    queueManager.enqueueRequest 'students', getAllStudentsRequestObject
                else
                    controllerInstance.getAllStudents @poolManager, (getAllStudentsError, allStudents) =>
                        if getAllStudentsError?
                            response.json 500, {error: getAllStudentsError.message}
                        else
                            response.json 200, allStudents

        _getStudent = (queueManager, request, response) ->
            @poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getStudentRequestObject =
                        methodName: 'getStudent'
                        arguments: [queueManager, request, response]
                    queueManager.enqueueRequest 'students', getStudentRequestObject
                else
                    controllerInstance.getStudent request.params.id, @poolManager, (getStudentError, studentDetails) =>
                        if getStudentError?
                            response.json 500, {error: getStudentError.message}
                        else
                            response.json 200, studentDetails

        _insertAllStudents = (queueManager, request, response) ->
            @poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    insertAllStudentsRequestObject =
                        methodName: 'insertAllStudents'
                        arguments: [queueManager, request, response]
                    queueManager.enqueueRequest 'students', insertAllStudentsRequestObject
                else
                    controllerInstance.insertAllStudents @poolManager, (studentCreationError, studentCreationResult) =>
                        if studentCreationError?
                            response.json 500, {error: studentCreationError.message}
                        else
                            response.json 201, studentCreationResult

        _updateCourses = (queueManager, request, response) ->
            @poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    updateCoursesRequestObject =
                        methodName: 'updateCourses'
                        arguments: [queueManager, request, response]
                    queueManager.enqueueRequest 'students', updateCoursesRequestObject
                else
                    controllerInstance.updateCourses request.params.id, request.body, @poolManager, (courseUpdateError, courseUpdateResult) =>
                        if courseUpdateError?
                            response.json 500, {error: courseUpdateError.message}
                        else
                            response.json courseUpdateResult

        constructor: ->
            @poolManager = PoolManager.getPoolManagerInstance()

        insertAllStudents: (queueManager, request, response) =>
            _insertAllStudents.call @, queueManager, request, response

        createPassword: (queueManager, request, response) =>
            _createPassword.call @, queueManager, request, response

        updateCourses: (queueManager, request, response) =>
            _updateCourses.call @, queueManager, request, response

        authenticate: (queueManager, request, response) =>
            _authenticate.call @, queueManager, request, response

        getAllStudents: (queueManager, request, response) =>
            _getAllStudents.call @, queueManager, request, response

        getStudent: (queueManager, request, response) =>
            _getStudent.call @, queueManager, request, response
