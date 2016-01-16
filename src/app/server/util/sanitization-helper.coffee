'use strict'

exports.CheckAndSanitizationHelper = class CheckAndSanitizationHelper

    # can be alpha numeric or numeric
    _checkAndSanitizeID = (idValue, nullIDErrorStr, errorStr, isAlphanumericType, validator, callback) ->
        if validator.isNull(idValue)
            nullIDError = new Error nullIDErrorStr
            callback nullIDError, null
        else
            if isAlphanumericType
                if not validator.isAlphanumeric(idValue)
                    invalidAlphanumericIDError = new Error errorStr
                    callback invalidAlphanumericIDError, null
                else
                    callback null, validator.trim(idValue)
            else
                if not validator.isAlpha idValue
                    invalidAlphaIDError = new Error errorStr
                    callback invalidAlphaIDError, null
                else
                    callback null, validator.trim(idValue)

    _checkAndSanitizeWords = (words, wordPartErrorStr, emptyWordErrorStr, validator, callback) ->
        wordComponentError = undefined
        wordComponents = words.split " "
        validWordComponents = []
        for wordComponentItem in wordComponents
            do (wordComponentItem) =>
                if validator.isNull(wordComponentItem) or not validator.isAlpha(wordComponentItem)
                    if not wordComponentError?
                        wordComponentError = new Error wordPartErrorStr
                else
                    validWordComponents.push validator.trim(wordComponentItem)
        if wordComponentError?
            callback wordComponentError, null
        else if validWordComponents.length > 0
            callback null, validWordComponents.join(' ')
        else
            emptyWordError = new Error emptyWordErrorStr
            callback emptyWordError, null

    _checkAndSanitizeDate = (dateValue, errorStr, validator, callback) ->
        if validator.isNull(dateValue) or not validator.isDate(dateValue)
            invalidDateError = new Error errorStr
            callback invalidDateError, null
        else
            callback null, validator.trim(dateValue)

    _checkAndSanitizeCode = (codeValue, errorStr, validator, callback) ->
        if validator.isNull(codeValue) or not validator.isAlphanumeric(codeValue)
            invalidCodeError = new Error errorStr
            callback invalidCodeError, null
        else
            callback null, validator.trim(codeValue)

    _checkAndSanitizePersonName = (personName, errorStr, validator, callback) ->
        if validator.isNull(personName) or not validator.isAlpha(personName)
            invalidNameError = new Error nameErrorStr
            callback invalidNameError, null
        else
            validName = validator.trim(personName)
            capitalizedValidName = validName[0].toUpperCase() + validName[1..-1].toLowerCase()
            callback null, capitalizedValidName

    _checkAndSanitizeTitle = (titleValue, errorStr, possibleValues, validator, callback) ->
        if validator.isNull(titleValue) or not (validator.isAlpha(titleValue) and validator.isIn(titleValue, possibleValues))
            invalidTitleError = new Error errorStr
            callback invalidTitleError, null
        else
            callback null, validator.trim(titleValue)


        if validator.isNull(titleValue) or not (validator.isAlpha(titleValue)  and validator.isIn(titleValue, ["Mr", "Mrs", "Ms", "Dr", "Prof"]))
            invalidTitleError = new Error "Invalid Organizer Title"
            callback invalidTitleError, null
        else
            callback null, validator.trim(titleValue)

    _checkAndSanitizeEmailAddress = (emailAddress, errorStr, validator, callback) ->
        if validator.isNull(emailAddress) or not validator.isEmail(emailAddress)
            invalidEmailAddressError = new Error errorStr
            callback invalidEmailAddressError, null
        else
            callback null, validator.trim(emailAddress)

    _checkAndSanitizeNumber = (numberValue, errorStr, validator, callback) ->
        if validator.isNull(studentNumber) or not validator.isNumeric(studentNumber)
            invalidStudentNumberError = new Error errorStr
            callback invalidStudentNumberError, null
        else
            callback null, validator.toInt(studentNumber)

    _checkAndSanitizeString = (strValue, errorStr, validator,  callback) ->
        if validator.isNull(strValue) or not validator.isAlpha(strValue)
            invalidNameError = new Error errorStr
            callback invalidNameError, null
        else
            callback null, validator.trim(strValue)

    constructor: ->

    checkAndSanitizeID: (idValue, nullIDErrorStr, errorStr, isAlphanumericType, validator, callback) =>
        _checkAndSanitizeID.call @, idValue, nullIDErrorStr, errorStr, isAlphanumericType, validator, (idError, validID) =>
            callback idError, validID

    checkAndSanitizeWords: (words, wordPartErrorStr, emptyWordErrorStr, validator, callback) =>
        _checkAndSanitizeWords.call @, words, wordPartErrorStr, emptyWordErrorStr, validator, (wordsError, validWords) =>
            callback wordsError, validWords

    checkAndSanitizeDate: (dateValue, errorStr, validator, callback) =>
        _checkAndSanitizeDate.call @, dateValue, errorStr, validator, (dateError, validDate) =>
            callback dateError, validDate

    checkAndSanitizeCode: (codeValue, errorStr, validator, callback) =>
        _checkAndSanitizeCode.call @, codeValue, errorStr, validator, (codeError, validCode) =>
            callback codeError, validCode

    checkAndSanitizePersonName: (personName, errorStr, validator, callback) =>
        _checkAndSanitizePersonName.call @, personName, errorStr, validator, (personNameError, validPersonName) =>
            callback personNameError, validPersonName

    checkAndSanitizeTitle: (titleValue, errorStr, possibleValues, validator, callback) =>
        _checkAndSanitizeTitle.call @, titleValue, errorStr, possibleValues, validator, (titleError, validTitle) =>
            callback titleError, validTitle

    checkAndSanitizeEmailAddress: (emailAddress, errorStr, validator, callback) =>
        _checkAndSanitizeEmailAddress.call @, emailAddress, errorStr, validator, (emailAddressError, validEmailAddress) =>
            callback emailAddressError, validEmailAddress

    checkAndSanitizeNumber = (numberValue, errorStr, validator, callback) =>
        _checkAndSanitizeNumber.call @, numberValue, errorStr, validator, (numberError, validNumber) =>
            callback numberError, validNumber

    checkAndSanitizeString: (strValue, errorStr, validator, callback) =>
        _checkAndSanitizeString.call @, strValue, errorStr, validator, (stringError, validString) =>
            callback stringError, validString
