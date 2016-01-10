/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

(function () {
    var days = ["Mon", "Tues", "Wed", "Thu", "Fri", "Sat", "Sun"];
    var date = new Date();
    var month = date.getMonth();
    var year = date.getFullYear();
    var running_day = function () {
	ndate = new Date(year, month, 1, 0, 0, 0, 0);
	return ndate.getDay();
    }();
    var app = angular.module('oweek', ['ngMaterial']);

    app.controller('calendar', function () {
	this.days = function () {
	    days = [];
	    for (var i = 1)
	}();
    });


});