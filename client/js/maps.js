/**
 * Created by Bertie on 1/14/2016.
 */

//Angular App Module and Controller
var app = angular.module('mapsApp', []);

app.controller('loadCity',function($scope, $http, $log) {
    $http.get('jdata.json')
        .success(function (responce) {
            var cities = responce.locations;
            cities = responce.locations;
            $log.info("calling inside");
            $log.info(cities);
            return cities;
        });
});
app.controller('MapCtrl', function ($scope, $http, $log) {

    var imgSize = 'height="200px" width="300px"';

    $http.get('jdata.json')
        .success(function (responce) {
            var cities = responce.locations;
            var myCity = cities[0];
            $log.info(myCity);

            var mapOptions = {
                zoom: 17,
                center: new google.maps.LatLng(-22.565764,17.075859),
                mapTypeId: google.maps.MapTypeId.TERRAIN,
                heading: 90,
                tilt: 45
            };

            $scope.map = new google.maps.Map(document.getElementById('map'), mapOptions);

            $scope.markers = [];

            var infoWindow = new google.maps.InfoWindow();

            var createMarker = function (myCity){

                var marker = new google.maps.Marker({
                    map: $scope.map,
                    position: new google.maps.LatLng(myCity.coordinates[0].lat, myCity.coordinates[0].long),
                    title: myCity.name,
                    icon: 'img/mapImg/mapMarker.png'
                    /*icon: info.icon*/
                });
                marker.content = '<div class="infoWindowContent">' + '<img src="' +  myCity.image[0].src+ '"' + imgSize +'">' + '<br>' + myCity.image[0].caption + '</div>';

                google.maps.event.addListener(marker, 'click', function(){
                    infoWindow.setContent('<h2>' + marker.title + '</h2>' + marker.content);
                    infoWindow.open($scope.map, marker);
                });

                $scope.markers.push(marker);

            };

            for (i = 0; i < cities.length; i++){
                createMarker(cities[i]);
            }

            $scope.openInfoWindow = function(e, selectedMarker){
                e.preventDefault();
                google.maps.event.trigger(selectedMarker, 'click');
            }
        });
});
