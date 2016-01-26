app.controller('userController', ['$scope', 'Api', function ($scope, Api) {
	$scope.userTest = Api.userTest;
	$scope.session = Api.session;
    }]);
