
app.controller('Council', ["$scope", "$http", "$log", function ($scope, $http, $log) {

	$http.get('../json/src.json')
		.success(function (response) {
		    $scope.members = response.council;
		    $log.info(response);
		});
    }]);