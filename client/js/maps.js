/**
 * Created by Bertie on 1/14/2016.
 */

//path where images can be found
var path = "img/mapImg/";

//For changing the size of the map images
var imgSize = 'height="200px" width="300px"';

//For changing the size of the panoramic map images
var imgSizePan = 'height="200px" width="650px"';

//Data to be displayed on map
var cities = [
    //Gates
    {
        city : 'Small Gate',
        lat : -22.564750,
        long : 17.076893,
        desc: '<img src="' + path +'Small Gate.jpg"' + imgSize + '">'

    },
    {
        city : 'Main Gate',
        lat : -22.566571,
        long : 17.077736,
        desc: '<img src="' + path +'Main Gate.jpg"' + imgSize + '">'
    },

    //Block S
    {
        city : 'Poly Heights',
        lat : -22.566196,
        long : 17.078181,
        desc: '<img src="' + path +'Poly Heights.jpg"' + imgSize + '">'
    },

    //Block A
    {
        city : 'Elisabeth Haus (Rectorate)',
        lat : -22.565836,
        long : 17.077285,
        desc: '<img src="' + path +'Elisabeth Haus.jpg"' + imgSize + '">'
    },
    {
        city : 'Sander Haus',
        lat : -22.566084,
        long : 17.077378,
        desc: '<img src="' + path +'Sander Haus.jpg"' + imgSize + '">'
    },
    {
        city : 'Administration Building',
        lat : -22.566362,
        long : 17.077594,
        desc: '<img src="' + path +'Administration Building.jpg"' + imgSize + '">'
    },
    {
        city : 'Land Management Building',
        lat : -22.566384,
        long : 17.077132,
        desc: '<img src="' + path +'Department of Land Management.jpg"' + imgSize + '">'
    },
    {
        city : 'Center for Life Long Learning (COLL)',
        lat : -22.566028,
        long : 17.076931,
        desc: '<img src="' + path +'COLL.jpg"' + imgSize + '">'
    },
    {
        city : 'Dean of Students',
        lat : -22.566013,
        long : 17.076677,
        desc: '<img src="' + path +'Dean of Students.jpg"' + imgSize + '">'
    },
    {
        city : 'Monresa Residence',
        lat : -22.566013,
        long : 17.076677,
        desc: '<img src="' + path +'Monresa Residence.jpg"' + imgSize + '">'
    },
    {
        city : 'Hopker Residence',
        lat : -22.566254,
        long : 17.076388,
        desc: '<img src="' + path +'Hopker Residence.jpg"' + imgSize + '">' + '<img src="' + path +'Hopker Residence Gate.jpg"' + imgSize + '">'
    },
    {
        city : 'Shangri-La Residence',
        lat : -22.565300,
        long : 17.076159,
        desc: '<img src="' + path +'Shangri-La Residence.jpg"' + imgSizePan + '">'
    },
    {
        city : 'Clinic',
        lat : -22.564942,
        long : 17.076562,
        desc: '<img src="' + path +'Clinic.jpg"' + imgSize + '">'
    },
    {
        city : 'Vocational Training',
        lat : -22.564905,
        long : 17.076790,
        desc: '<img src="' + path +'Vocational Training.jpg"' + imgSize + '">'
    },
    {
        city : 'Oppenheimer House',
        lat : -22.564873,
        long : 17.077130,
        desc: '<img src="' + path +'Oppenheimer House.jpg"' + imgSize + '">'
    },
    {
        city : 'Dawakos House',
        lat : -22.564822,
        long : 17.077347,
        desc: '<img src="' + path +'Dawakos House.jpg"' + imgSize + '">'
    },
    {
        city : 'Centre for Enterprise Development',
        lat : -22.564743,
        long : 17.077657,
        desc: '<img src="' + path +'Centre For Enterprise Development.jpg"' + imgSize + '">'
    },
    {
        city : 'Lecture Building',
        lat : -22.565119,
        long : 17.077756,
        desc: '<img src="' + path +'Lecture Building.jpg"' + imgSize + '">'
    },
    {
        city : 'Info Center and Kiosk',
        lat : -22.565314,
        long : 17.077374,
        desc: '<img src="' + path +'Kiosk.jpg"' + imgSize + '">'
    },
    {
        city : 'Office Building',
        lat : -22.565268,
        long : 17.077106,
        desc: '<img src="' + path +'Office Building.jpg"' + imgSize + '">'
    },

    //Block B
    {
        city : 'Quality Assurance Unit',
        lat : -22.564156,
        long : 17.076929,
        desc: '<img src="' + path +'Quality Assurance Unit.png"' + imgSize + '">'
    },

    //Block C
    {
        city : 'Foundation House',
        lat : -22.564507,
        long : 17.076592,
        desc: '<img src="' + path +'Foundation House.jpg"' + imgSize + '">'
    },

    //Block D
    {
        city : 'Library',
        lat : -22.564356,
        long : 17.075340,
        desc: '<img src="' + path +'Library.jpg"' + imgSize + '">'
    },
    {
        city : 'Engineering Building',
        lat : -22.565027,
        long : 17.074515,
        desc: '<img src="' + path +'Engineering Building.jpg"' + imgSize + '">'
    },
    {
        city : 'Auditorium Building',
        lat : -22.565280,
        long : 17.074969,
        desc: '<img src="' + path +'Auditorium Building.jpg"' + imgSize + '">'
    },
    {
        city : 'Science and Technology Building',
        lat : -22.565703,
        long : 17.074561,
        desc: '<img src="' + path +'Science and Technology Building.jpg"' + imgSize + '">'
    },

    //Block E
    {
        city : 'School of Health and Applied Sciences',
        lat : -22.566150,
        long : 17.073797,
        desc: '<img src="' + path +'School of Health and Applied Science.jpg"' + imgSize + '">'
    },
    {
        city : 'Mechanical Engineering Building',
        lat : -22.565675,
        long : 17.073580,
        desc: '<img src="' + path +'Mechanical Engineering Building.jpg"' + imgSize + '">'
    },
    {
        city : 'Civil Engineering Building',
        lat : -22.565749,
        long : 17.073354,
        desc: '<img src="' + path +'Civil Engineering Building.jpg"' + imgSize + '">'
    },
    {
        city : 'Architecture Building',
        lat : -22.565956,
        long : 17.073084,
        desc: '<img src="' + path +'Architecture Building.jpg"' + imgSize + '">'
    },

    //Block F
    {
        city : 'Hotel School',
        lat : -22.566503,
        long : 17.072268,
        desc: '<img src="' + path +'Hotel School.jpg"' + imgSize + '">'
    },
    {
        city : 'Pre-Fabricated Classrooms',
        lat : -22.567008,
        long : 17.071749,
        desc: '<img src="' + path +'Pre-Fabricated Classrooms.jpg"' + imgSize + '">'
    },
    {
        city : 'New Energy Efficient House',
        lat : -22.567208,
        long : 17.071518,
        desc: '<img src="' + path +'New Energy Effecient House.jpg"' + imgSize + '">'
    },

    //Block J
    {
        city : 'Teaching and Learning Unit',
        lat : -22.565177,
        long : 17.075662,
        desc: '<img src="' + path +'Teaching and Learning Unit.jpg"' + imgSize + '">'
    },
    {
        city : 'Hyden Street No.9',
        lat : -22.565477,
        long : 17.075688,
        desc: '<img src="' + path +'Hyden Street No 9.jpg"' + imgSize + '">'
    },
    {
        city : "Daniel's Guest House",
        lat : -22.565850,
        long : 17.075615,
        desc: '<img src="' + path + 'Daniels Guest House.jpg"' + imgSize + '">'
    },
    {
        city : 'REEI House',
        lat : -22.565923,
        long : 17.075076,
        desc: '<img src="' + path +'Reei House.jpg"' + imgSize + '">'
    },
    {
        city : 'NBIC',
        lat : -22.566280,
        long : 17.074577,
        desc: '<img src="' + path +'NBIC.jpg"' + imgSize + '">' + '<img src="' + path +'NBIC 2.jpg"' + imgSize + '">'
    },
    {
        city : 'Namibia German Center for Logistics',
        lat : -22.566507,
        long : 17.075179,
        desc: '<img src="' + path +'Namibia-German Center for Logistics.jpg"' + imgSize + '">'
    },
    {
        city : 'Gluck Street No.5',
        lat : -22.566745,
        long : 17.074911,
        desc: '<img src="' + path +'Gluck Street No 5.jpg"' + imgSize + '">'
    },

    //Block K
    {
        city : 'Architecture House',
        lat : -22.566658,
        long : 17.075645,
        desc: '<img src="' + path +'Architecture House.jpg"' + imgSize + '">'
    },

    //Block L
    {
        city : 'Information Technology House',
        lat : -22.567067,
        long : 17.077560,
        desc: '<img src="' + path +'IT House.jpg"' + imgSize + '">'
    },

    //Block O
    {
        city : 'Hotel Pension Kleines Heim',
        lat : -22.568226,
        long : 17.070541,
        desc: '<img src="' + path +'Hotel Pension.jpg"' + imgSize + '">' + '<img src="' + path +'Hotel Pension Sign.jpg"' + imgSize + '">'
    }
];

//Angular App Module and Controller
app.controller('MapCtrl',["$scope", function ($scope) {

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

    var createMarker = function (info){

        var marker = new google.maps.Marker({
            map: $scope.map,
            position: new google.maps.LatLng(info.lat, info.long),
            title: info.city,
            icon: 'img/mapImg/mapMarker.png'
            /*icon: info.icon*/
        });
        marker.content = '<div class="infoWindowContent">' + info.desc + '</div>';

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
    };

}]);
