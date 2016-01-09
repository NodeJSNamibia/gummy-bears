'use strict'

exports.AcademicStructureLoader = class AcademicStructureLoader
    _loaderInstance = undefined

    @getAcademicStructureLoader = ->
        _loaderInstance ?= new _LocalAcademicStructureLoader

    class _LocalAcademicStructureLoader

        constructor: ->

        loadStructure: (callback) =>
            configObj =
                input: __dirname + '/../../../var/faculties.xls'
                output: null
                sheet: "Sheet 1"
            xlsxj configObj, callback
