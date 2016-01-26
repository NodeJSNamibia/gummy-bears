var myApp = angular.module('cardDemo', []);

myApp.controller ('AppCtrl', function($scope, $http, $log) {

	$http.get('council.json')
		.succes(function(response){
			$scope.COUNCIL = response.council;
			$log.info(response);
		});
});