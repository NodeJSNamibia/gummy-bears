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
