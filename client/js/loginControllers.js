var app = angular.module('login', []);

app.controller ('submitCtrl', function($scope) {

  $scope.go = function() {
      $scope.psw = $scope.password;
      $scope.stNum = $scope.studentNum;

      $scope.authData = $scope.stNum + ":" +$scope.psw;

      $http.post(url, $scope.authData)
          .then(
              function(response){
                  // success callback
              },
              function(response){
                  // failure callback
              }
          );
 }

});
