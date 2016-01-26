'use strict'

module.exports = (app) ->

    # unique route to the single page
    app.route('/').get (request, response) ->
        response.render 'index.html'

    app.route('partials/:name').get (request, response) ->
        partialName = "partials/#{request.params.name}"
        response.render partialName
