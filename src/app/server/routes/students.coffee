'use strict'

StudentsController = require('../controllers/students').StudentsController

module.exports = (app, dataManager) ->
    app.route('/students').post (request, response) ->
        # creating a new student information
        new StudentsController(dataManager).createStudent (studentCreationError, studentCreationResult) =>
            if studentCreationError?
                response.json 500, {error: studentCreationError.message}
            else
                response.json studentCreationResult
