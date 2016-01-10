/*
 * To change $scope license header, choose License Headers in Project Properties.
 * To change $scope template file, choose Tools | Templates
 * and open the template in the editor.
 */

(function () {
    var wdays = ["Mon", "Tues", "Wed", "Thu", "Fri", "Sat", "Sun"];
    var date = new Date();
    var month = date.getMonth();
    var year = date.getFullYear();
    ndate = new Date(year, month, 1, 0, 0, 0, 0);
    var running_day = ndate.getDay();
    var app = angular.module('oweek', ['ngMaterial', 'ngRoute'])
	    .config(['$routeProvider', function ($routeProvider) {
		    $routerProvider.when("/login", {
			templateUrl: "partials/login.html",
			controller: "LoginController"
		    });
		}
	    ]
		    );

    app.controller('Calendar', function ($scope) {
	$scope.wdays = wdays;
	$scope.year = year;
	$scope.month_name = moment(ndate).format("MMMM");
	$scope.days = fillDays();
	$scope.next = function () {
	    monthAdd(1);
	    $scope.year = year;
	    ndate = new Date(year, month, 1, 0, 0, 0, 0);
	    running_day = ndate.getDay();
	    $scope.month_name = moment(ndate).format("MMMM");
	    $scope.days = fillDays();

	};

	$scope.previous = function () {
	    monthAdd(-1);
	    $scope.year = year;
	    ndate = new Date(year, month, 1, 0, 0, 0, 0);
	    running_day = ndate.getDay();
	    $scope.month_name = moment(ndate).format("MMMM");
	    $scope.days = fillDays();

	};
    });

    function fillDays() {
	last_day = moment(ndate).endOf('month').date();
	var days = [];
	var i;
	for (i = 1; i < running_day; i++) {
	    days.push(" ");

	}
	for (var j = 1; j <= last_day; j++) {
	    days.push(j);
	}
	return days;
    }

    function monthAdd(add, scope) {
	month += add;
	if (month >= 12) {
	    month = 0;
	    year += 1;
	} else if (month <= -1) {
	    month = 11;
	    year -= 1;
	}
    }
})();