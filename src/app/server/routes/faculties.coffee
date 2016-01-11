'use strict'

# this file contains all routes related to academic structure and
# course timetables

FacultyRequestHandler = require('../route-handlers/faculty').FacultyRequestHandler

module.exports = (app, poolManager, queueManager) ->
    facultyRequestHandler = FacultyRequestHandler.getRequestHandler()

    # load the academic structure of the institution
    app.route('/api/faculties').post (request, response) ->
        facultyRequestHandler.insertAcademicStructure queueManager, poolManager, request, response

    # get the list of faculties
    app.route('/api/faculties').get (request, response) ->
        facultyRequestHandler.getAllFaculties queueManager, poolManager, request, response

    # get a specific faculty with its id
    app.route('/api/faculty/:id').get (request, response) ->
        facultyRequestHandler.getFaculty queueManager, poolManager, request, response
