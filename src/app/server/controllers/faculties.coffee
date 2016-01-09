'use strict'

AbstractController = require('./abstract-controller').AbstractController
FacultyModel       = require('../models/faculty').FacultyModel

exports.FacultiesController = class FacultiesController extends AbstractController

    _insertAcademicStructure = (poolManager, queueManager, callback) ->
        

    constructor: (envVal) ->
        faculty = new FacultyModel envVal

    insertAcademicStructure: (poolManager, queueManager, callback) =>
        _insertAcademicStructure.call @, poolManager, queueManager, (insertAllError, insertAllResult) =>
            callback insertAllError, insertAllResult
