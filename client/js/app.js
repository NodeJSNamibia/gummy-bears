/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var wdays = ["Mon", "Tues", "Wed", "Thu", "Fri", "Sat", "Sun"];
var date = new Date();
var month = date.getMonth();
var year = date.getFullYear();
ndate = new Date(year, month, 1, 0, 0, 0, 0);
var running_day = ndate.getDay();
var app = angular.module('oweek', ['ngMaterial', 'ngRoute']);
app.config(['$routeProvider', '$locationProvider', function ($routeProvider, $locationProvider) {
	$locationProvider.html5Mode(true);
	$routeProvider.when("/login", {
	    templateUrl: "partials/login.html",
	}).when("/", {
	    templateUrl: "partials/index.html",
	    controller: "Calendar"
	}).when("/user", {
	    templateUrl: "partials/user.html"
	}).otherwise({redirectTo: '/'});
    }
]
	);

// API Service

app.service('Api', ['$http', "$location", function ($http, $location) {

	var user = {
	    authenticated: false,
	    details: {},
	    authenticate: function (studentNumber, studentPin) {
		$http.post("auth/login", {studentNumber: studentNumber, studentPin: studentPin}).then(function (data) {
		    user.details = data;
		    authenticated = true;
		}, function (data) {

		});
	    }
	};
	var userTest = {
	    authenticated: false,
	    details: {},
	    authenticate: function (studentNumber, studentPin) {
		if (studentNumber === "201019593", studentPin === "34341") {
		    userTest.details = {
			name: "Field",
			surname: "Marshal",
			student_number: "201019593",
			faculty: "Faculty of Engineering",
			programme: "Beng Mechanical Engineering",
			dept: "Department of Mechanical Engineering"
		    };
		    userTest.authenticated = true;
		    $location.path("/user");
		} else {
		    alert("Invalid Login");
		}
	    }
	};
	this.userTest = userTest;
    }]);
var settings = {
    displayLogin: true
};

app.controller('Calendar', function () {
    this.wdays = wdays;
    this.year = year;
    this.month_name = moment(ndate).format("MMMM");
    this.days = fillDays();
    this.next = function () {
	monthAdd(1);
	this.year = year;
	ndate = new Date(year, month, 1, 0, 0, 0, 0);
	running_day = ndate.getDay();
	this.month_name = moment(ndate).format("MMMM");
	this.days = fillDays();

    };

    this.previous = function () {
	monthAdd(-1);
	this.year = year;
	ndate = new Date(year, month, 1, 0, 0, 0, 0);
	running_day = ndate.getDay();
	this.month_name = moment(ndate).format("MMMM");
	this.days = fillDays();

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

function monthAdd(add) {
    month += add;
    if (month >= 12) {
	month = 0;
	year += 1;
    } else if (month <= -1) {
	month = 11;
	year -= 1;
    }
}


app.controller('loginController', ['$scope', 'Api', function ($scope, Api) {
	$scope.user = {
	    number: '',
	    pin: ''
	};
	$scope.auth = function () {
	    Api.userTest.authenticate($scope.user.number, $scope.user.pin);
	};
    }]);

app.controller("homeController", ["$scope", 'Api', function ($scope, Api) {
	$scope.api = Api.userTest;
    }]);