'use strict'

# This class represents a students controller. It handles all requests related to students

StudentModel = require('../models/student').StudentModel

exports.StudentsController = class StudentsController
    constructor: (dataManager) ->
        @student = new StudentModel dataManager

    createStudent: (callback) =>
        # will create a student
