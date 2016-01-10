/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

(function () {
    var wdays = ["Mon", "Tues", "Wed", "Thu", "Fri", "Sat", "Sun"];
    var date = new Date();
    var month = date.getMonth();
    var year = date.getFullYear();
    ndate = new Date(year, month, 1, 0, 0, 0, 0);
    var running_day = function () {
	return ndate.getDay();
    }();
    var app = angular.module('oweek', ['ngMaterial']);

    app.controller('Calendar', function () {
	this.wdays = wdays;
	this.year = year;
	this.month_name = moment(ndate).format("MMMM");
	this.days = function () {
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
	}();
    });


})();