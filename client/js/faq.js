/**
 * Created by Bertie on 1/23/2016.
 */

app.controller("faqCtrl", function ($scope, $http, $log, $anchorScroll) {

    $http.get('../faq.json') //URL to be changes to address at server
        .success(function (responce) {
            $scope.FAQ = responce.questions;
            $log.info($scope.FAQ);
        });
});
