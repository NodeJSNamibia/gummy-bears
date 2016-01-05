'use strict'

# this file contains all the routes related to student resource

QueueManager          = require('../lib/queue-manager').QueueManager
StudentRequestHandler = require('../route-handlers/student').StudentRequestHandler

module.exports = (app) ->

    queueManager = QueueManager.getQueueManagerInstance()
    studentRequestHandler = StudentRequestHandler.getRequestHandler()

    # load all students
    app.route('/api/students').post (request, response) ->
        studentRequestHandler.insertAllStudents queueManager, request, response

    # create a pasword for the student
    app.route('/api/students/password/:id').put (request, response) ->
        studentRequestHandler.createPassword queueManager, request, response

    # add the courses the student registered for
    app.route('/api/students/courses/:id').put (request, response) ->
        studentRequestHandler.updateCourses queueManager, request, response

    # default student authentication
    app.route('/api/students/authenticate').post (request, response) ->
        studentRequestHandler.authenticate queueManager, request, response

    # get the list of students
    app.route('/api/students').get (request, response) ->
        studentRequestHandler.getAllStudents queueManager, request, response

    # get a specific student with her student number as an id
    app.route('/api/students/:id').get (request, response) ->
        studentRequestHandler.getStudent queueManager, request, response
