'use strict'

# this file contains all the routes related to student resource

StudentRequestHandler = require('../route-handlers/student').StudentRequestHandler

module.exports = (app, poolManager, queueManager) ->
    studentRequestHandler = StudentRequestHandler.getRequestHandler()

    # load all students
    app.route('/api/students').post (request, response) ->
        studentRequestHandler.insertAllStudents queueManager, poolManager, request, response

    # create a pasword for the student
    app.route('/api/students/password/:id').put (request, response) ->
        studentRequestHandler.createPassword queueManager, poolManager, request, response

    # add the courses the student registered for
    app.route('/api/students/courses/:id').put (request, response) ->
        studentRequestHandler.updateCourses queueManager, poolManager, request, response

    # default student authentication
    app.route('/api/students/authenticate').post (request, response) ->
        studentRequestHandler.authenticate queueManager, poolManager, request, response

    # get the list of students
    app.route('/api/students').get (request, response) ->
        studentRequestHandler.getAllStudents queueManager, poolManager, request, response

    # get a specific student with her student number as an id
    app.route('/api/students/:id').get (request, response) ->
        studentRequestHandler.getStudent queueManager, poolManager, request, response
