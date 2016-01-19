### HTTP Request with Angular.js

Assuming you wish to submit an **HTTP** request from your client-side code (i.e. Angular.js code).

```javascript
var app = angular.module('appName', ['ngRoute']);
app.service('servName', ['$http', function($http){
    var myMethods = {
        sayHi: function(friend) {
            $http.post("/some/url", {name: friend.name, email: friend.email}).then(function(data){
                // the success code goes here
            }, function(data{
                // the error code goes here
            }));
        }
    };
}]);
```

The **sayHi** can then be called from any controller, provided the service name is injected in the controller.

Another alternative is to inject the **$http** service in the controller directly. The following example shows

```javascript
app.controller("ControllerName", function($http){
    // normal instructions
    $http.post('/api/students/authenticate', JSON.stringify(content)).
        success(function(data){
            // the code when the request succeeds
        }).
        error(function(data){
            // the code when the request fails
        })
});
```
