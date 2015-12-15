'use strict'

StudentsController = require('../controllers/students').StudentsController

module.exports = (app, configOptions) ->
    app.route('/students').post (request, response) ->
        new StudentsController(configOptions.dbURL).insertAllStudents (studentCreationError, studentCreationResult) =>
            if studentCreationError?
                response.json 500, {error: studentCreationError.message}
            else
                response.json studentCreationResult
