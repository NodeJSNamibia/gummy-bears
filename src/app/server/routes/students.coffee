'use strict'

StudentsController = require('../controllers/students').StudentsController

module.exports = (app) ->
    # might need a pool of student controllers.
    # Will use a pool manager to grab one
    studentsController = new StudentsController app.settings.env
    app.route('/api/students').post (request, response) ->
        studentsController.insertAllStudents (studentCreationError, studentCreationResult) =>
            if studentCreationError?
                response.json 500, {error: studentCreationError.message}
            else
                response.json studentCreationResult

    app.route('/api/students/password/:id').put (request, response) ->
        studentsController.createPassword request.params.id, request.body, (passwordCreationError, passwordCreationResult) =>
            if passwordCreationError?
                response.json 500, {error: passwordCreationError.message}
            else
                response.json passwordCreationResult

    app.route('/api/students/courses/:id').put (request, response) ->
        studentsController.updateCourses request.params.id, request.body, (courseUpdateError, courseUpdateResult) =>
            if courseUpdateError?
                response.json 500, {error: courseUpdateError.message}
            else
                response.json courseUpdateResult

    app.route('/api/students/authenticate').post (request, response) ->
        studentsController.authenticate request.body, (authenticationError, authenticationResult) =>
            if authenticationError?
                response.json 500, {error: authenticationError.message}
            else
                response.json authenticationResult

    app.route('/api/students').get (request, response) ->
        studentsController.getAllStudents (getAllStudentsError, allStudents) =>
            if getAllStudentsError?
                response.json 500, {error: getAllStudentsError.message}
            else
                response.json allStudents

    app.route('/api/students/:id').get (request, response) ->
        studentsController.getStudent request.params.id, (getStudentError, studentDetails) =>
            if getStudentError?
                response.json 500, {error: getStudentError.message}
            else
                response.json studentDetails
