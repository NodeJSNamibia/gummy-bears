'use strict'

bcrypt = require 'bcrypt'

exports.PasswordHandler = class PasswordHandler
    _hashPassword = (clearPasswordText, callback) ->
        bcrypt.genSalt 9, (saltError, saltValue) =>
            if saltError?
                callback saltError, null
            else
                bcrypt.hash clearText, saltValue, (hashError, hashedPassword) =>
                    if hashError?
                        hashPasswordError = new Error "Error geenrating a hashed version of the password"
                        callback hashPasswordError, null
                    else
                        callback null, hashedPassword

    _verifyPassword = (clearPasswordText, hashedPassword, callback) ->
        bcrypt.compare clearPasswordText, hashedPassword, (compareError, compareResult) =>
            callback compareError, compareResult

    constructor: ->

    hashPassword: (clearText, callback) =>
        _hashPassword.call @, clearText, (hashError, hashedPassword) =>
            callback hashError, hashedPassword

    verifyPassword: (clearPasswordText, hashedPassword, callback) =>
        _verifyPassword.call @, clearPasswordText, hashedPassword, (verifyError, verifyResult) =>
            callback verifyError, verifyResult
