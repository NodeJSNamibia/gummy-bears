'use strict'

# this file contains all routes related to academic structure and
# course timetables

FacultyRequestHandler = require('../route-handlers/faculty').FacultyRequestHandler

module.exports = (app, poolManager, queueManager) ->
    facultyRequestHandler = FacultyRequestHandler.getRequestHandler()
