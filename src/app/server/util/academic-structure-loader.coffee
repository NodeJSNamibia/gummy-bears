'use strict'

exports.AcademicStructureLoader = class AcademicStructureLoader
    _loaderInstance = undefined

    @getAcademicStructureLoader = ->
        _loaderInstance ?= new _LocalAcademicStructureLoader

    class _LocalAcademicStructureLoader

        constructor: ->

        loadStructure: (callback) =>
            facConfigObj =
                input: __dirname + '/../../../var/faculties.xls'
                output: null
                sheet: "Sheet 1"
            xlsxj facConfigObj, callback
