'use strict'

StudentsController = require('../controllers/students').StudentsController

module.exports = (app, dataManager) ->
    app.route('/students').post (request, response) ->
        # creating a new student information
        # this is still a work in progress
        new StudentsController(dataManager).saveAllStudent (studentCreationError, studentCreationResult) =>
            if studentCreationError?
                response.json 500, {error: studentCreationError.message}
            else
                response.json studentCreationResult
