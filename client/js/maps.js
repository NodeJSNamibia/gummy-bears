/**
 * Created by Bertie on 1/14/2016.
 */

// Map Controller
app.controller('MapCtrl', function ($scope, $http, $log) {

    var imgSize = 'height="200px" width="300px"';

    $http.get('jdata.json') //URL to be changes to address at server
        .success(function (responce) {
            var mapLocations = responce.locations;
            var location = mapLocations[0];
            $log.info(location);

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

            var createMarker = function (location){

                var marker = new google.maps.Marker({
                    map: $scope.map,
                    position: new google.maps.LatLng(location.coordinates[0].lat, location.coordinates[0].long),
                    title: location.name,
                    icon: 'img/mapMarker.png'
                });
                marker.content = '<div class="infoWindowContent">' + '<img src="' +  location.image[0].src+ '"' + imgSize +'">' + '<br>' + location.image[0].caption + '</div>';

                google.maps.event.addListener(marker, 'click', function(){
                    infoWindow.setContent('<h2>' + marker.title + '</h2>' + marker.content);
                    infoWindow.open($scope.map, marker);
                });

                $scope.markers.push(marker);

            };

            for (i = 0; i < mapLocations.length; i++){
                createMarker(mapLocations[i]);
            }

            $scope.openInfoWindow = function(e, selectedMarker){
                e.preventDefault();
                google.maps.event.trigger(selectedMarker, 'click');
            }
        });
});
