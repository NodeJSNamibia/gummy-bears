'use strict'

AbstractController = require('./abstract-controller').AbstractController
FacultyModel       = require('../models/faculty').FacultyModel

exports.FacultiesController = class FacultiesController extends AbstractController

    constructor: (envVal) ->
        faculty = new FacultyModel envVal
