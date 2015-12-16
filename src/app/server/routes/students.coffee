'use strict'

StudentsController = require('../controllers/students').StudentsController

module.exports = (app) ->
    app.route('/api/students').post (request, response) ->
        new StudentsController(app.settings.env).insertAllStudents (studentCreationError, studentCreationResult) =>
            if studentCreationError?
                response.json 500, {error: studentCreationError.message}
            else
                response.json studentCreationResult
