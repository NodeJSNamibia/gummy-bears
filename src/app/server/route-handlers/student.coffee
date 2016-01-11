'use strict'

exports.StudentRequestHandler = class StudentRequestHandler
    _srhInstance = undefined

    @getRequestHandler: ->
        _srhInstance ?= new _LocalStudentRequestHandler

    class _LocalStudentRequestHandler

        _authenticate = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    authenticationRequestObject =
                        methodName: 'authenticate'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'students', authenticationRequestObject
                else
                    controllerInstance.authenticate request.body, poolManager, queueManager, (authenticationError, authenticationResult) =>
                        if authenticationError?
                            response.json 500, {error: authenticationError.message}
                        else
                            response.json 200, authenticationResult

        _createPassword = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    createPasswordRequestObject =
                        methodName: 'createPassword'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'students', createPasswordRequestObject
                else
                    controllerInstance.createPassword request.params.id, request.body, poolManager, queueManager, (passwordCreationError, passwordCreationResult) =>
                        if passwordCreationError?
                            response.json 500, {error: passwordCreationError.message}
                        else
                            response.json 200, passwordCreationResult

        _getAllStudents = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getAllStudentsRequestObject =
                        methodName: 'getAllStudents'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'students', getAllStudentsRequestObject
                else
                    controllerInstance.getAllStudents poolManager, queueManager, (getAllStudentsError, allStudents) =>
                        if getAllStudentsError?
                            response.json 500, {error: getAllStudentsError.message}
                        else
                            response.json 200, allStudents

        _getStudent = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getStudentRequestObject =
                        methodName: 'getStudent'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'students', getStudentRequestObject
                else
                    controllerInstance.getStudent request.params.id, poolManager, queueManager, (getStudentError, studentDetails) =>
                        if getStudentError?
                            response.json 500, {error: getStudentError.message}
                        else
                            response.json 200, studentDetails

        _insertAllStudents = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    insertAllStudentsRequestObject =
                        methodName: 'insertAllStudents'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'students', insertAllStudentsRequestObject
                else
                    controllerInstance.insertAllStudents poolManager, queueManager, (studentCreationError, studentCreationResult) =>
                        if studentCreationError?
                            response.json 500, {error: studentCreationError.message}
                        else
                            response.json 201, studentCreationResult

        _updateCourses = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    updateCoursesRequestObject =
                        methodName: 'updateCourses'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'students', updateCoursesRequestObject
                else
                    controllerInstance.updateCourses request.params.id, request.body, poolManager, queueManager, (courseUpdateError, courseUpdateResult) =>
                        if courseUpdateError?
                            response.json 500, {error: courseUpdateError.message}
                        else
                            response.json courseUpdateResult

        constructor: ->

        insertAllStudents: (queueManager, poolManager, request, response) =>
            _insertAllStudents.call @, queueManager, poolManager, request, response

        createPassword: (queueManager, poolManager, request, response) =>
            _createPassword.call @, queueManager, poolManager, request, response

        updateCourses: (queueManager, poolManager, request, response) =>
            _updateCourses.call @, queueManager, poolManager, request, response

        authenticate: (queueManager, poolManager, request, response) =>
            _authenticate.call @, queueManager, poolManager, request, response

        getAllStudents: (queueManager, poolManager, request, response) =>
            _getAllStudents.call @, queueManager, poolManager, request, response

        getStudent: (queueManager, poolManager,  request, response) =>
            _getStudent.call @, queueManager, poolManager, request, response
