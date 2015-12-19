'use strict'

StudentsController = require('../controllers/students').StudentsController

module.exports = (app) ->
    # will have to decide whether a controller should be created each time
    app.route('/api/students').post (request, response) ->
        new StudentsController(app.settings.env).insertAllStudents (studentCreationError, studentCreationResult) =>
            if studentCreationError?
                response.json 500, {error: studentCreationError.message}
            else
                response.json studentCreationResult

    app.route('/api/students/password/:id').put (request, response) ->
        new StudentsController(app.settings.env).createPassword request.params.id, request.body, (passwordCreationError, passwordCreationResult) =>
            if passwordCreationError?
                response.json 500, {error: passwordCreationError.message}
            else
                response.json passwordCreationResult
