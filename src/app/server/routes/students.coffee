'use strict'

# this file contains all the routes related to student resource

PoolManager = require('../lib/pool-manager').PoolManager

module.exports = (app) ->

    # grab an instance of the pool manager
    poolManager = PoolManager.getPoolManagerInstance()

    # load all students
    app.route('/api/students').post (request, response) ->
        poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
            if controllerInstanceError?
                response.json 500, {error: controllerInstanceError.message}
            else if not controllerInstance?
                # add to the queue
            else
                controllerInstance.insertAllStudents poolManager, (studentCreationError, studentCreationResult) =>
                    if studentCreationError?
                        response.json 500, {error: studentCreationError.message}
                    else
                        response.json 201, studentCreationResult

    # create a pasword for the student
    app.route('/api/students/password/:id').put (request, response) ->
        poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
            if controllerInstanceError?
                response.json 500, {error: controllerInstanceError.message}
            else if not controllerInstance?
                # add to the queue
            else
                controllerInstance.createPassword request.params.id, request.body, poolManager, (passwordCreationError, passwordCreationResult) =>
                    if passwordCreationError?
                        response.json 500, {error: passwordCreationError.message}
                    else
                        response.json 200, passwordCreationResult

    # add the courses the student registered for
    app.route('/api/students/courses/:id').put (request, response) ->
        poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
            if controllerInstanceError?
                response.json 500, {error: controllerInstanceError.message}
            else if not controllerInstance?
                # add to the queue
            else
                controllerInstance.updateCourses request.params.id, request.body, poolManager, (courseUpdateError, courseUpdateResult) =>
                    if courseUpdateError?
                        response.json 500, {error: courseUpdateError.message}
                    else
                        response.json courseUpdateResult

    # default student authentication
    app.route('/api/students/authenticate').post (request, response) ->
        poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
            if controllerInstanceError?
                response.json 500, {error: controllerInstanceError.message}
            else if not controllerInstance?
                # add to the queue
            else
                controllerInstance.authenticate request.body, poolManager, (authenticationError, authenticationResult) =>
                    if authenticationError?
                        response.json 500, {error: authenticationError.message}
                    else
                        response.json authenticationResult

    # get the list of students
    app.route('/api/students').get (request, response) ->
        poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
            if controllerInstanceError?
                response.json 500, {error: controllerInstanceError.message}
            else if not controllerInstance?
                # add to the queue
            else
                controllerInstance.getAllStudents poolManager, (getAllStudentsError, allStudents) =>
                    if getAllStudentsError?
                        response.json 500, {error: getAllStudentsError.message}
                    else
                        response.json 200, allStudents

    # get a specific student with her student number as an id
    app.route('/api/students/:id').get (request, response) ->
        poolManager.acquire 'students', (controllerInstanceError, controllerInstance) =>
            if controllerInstanceError?
                response.json 500, {error: controllerInstanceError.message}
            else if not controllerInstance?
                # add to the queue
            else
                controllerInstance.getStudent request.params.id, poolManager, (getStudentError, studentDetails) =>
                    if getStudentError?
                        response.json 500, {error: getStudentError.message}
                    else
                        response.json 200, studentDetails
