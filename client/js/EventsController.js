/**
 * Created by erassy on 1/14/2016.
 */
var app = angular.module('oweek',[]);

app.controller('eventsController',function($scope,$http,$log){
    $scope.eventsArray ={};
    $http.get('../js/events.json')
    .success(function(response){
        $scope.eventsArray = response.events;
            $log.info(eventsArray);
    });
});
