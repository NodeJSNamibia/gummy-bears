'use strict'

bcrypt = require 'bcrypt'

exports.PasswordHandler = class PasswordHandler
    constructor: ->

    hashPassword: (clearText, callback) =>
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
