/**
 * Created by Omagano on 1/24/2016.
 */


app.controller("facultyCtrl",function ($scope, $http,$log, $anchorScroll) {
    $scope.facultyArray ={};
    $http.get('../partials/faculty.json')
        .success(function(response){
            $scope.facultyArray = response.Faculty;
            $log.info(facultyArray);


        });


});
