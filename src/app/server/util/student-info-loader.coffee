'use strict'

xlsxj = require 'xlsx-to-json'

exports.StudentInfoLoader = class StudentInfoLoader

    _loaderInstance = undefined

    @getStudentInfoLoader = ->
        _loaderInstance ?= new _LocalStudentInfoLoader

        class _LocalStudentInfoLoader
            constructor: ->

            loadStudents: (callback) =>
                convConfig =
                    input: __dirname + '/../../../opt/students.xls'
                    output: null
                    sheet: "Sheet 1"
                xlsxj convConfig, callback
