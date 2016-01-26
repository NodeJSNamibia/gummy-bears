/**
 * Created by Bertie on 1/23/2016.
 */

var app = angular.module("myApp", []);

app.controller("faqCtrl", function ($scope, $http, $log) {

    $http.get('../faq.json') //URL to be changes to address at server
        .success(function (responce) {
            $scope.FAQ = responce.questions;
            $log.info(FAQ);
        });
});