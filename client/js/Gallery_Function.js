(function(){

    app.controller("imageController", ['$scope', '$element', '$interval', function($scope, $element, $interval){
        // $scope.el

        $scope.image = [];

        $scope.small = [
            {

                breed: "Motivational",
                image: "Gallery Images/100_0116.JPG",


            },
            {

                breed: "German Shepherd",
                image: "img/Gallery Images/55682562.jpg"
            },
            {
                breed: "Golden Retriever",
                image: "img/Gallery Images/retriever.jpg"
            },
            {

                breed: "Bernese Mountain Dog",
                image: "img/Gallery Images/bernese.jpg"
            },
            {

                breed: "Corgi",
                image: "img/Gallery Images/corgi-1.jpg"
            },
            {

                breed: "Corgi",
                image: "img/Gallery Images/corgi-2.jpg"
            }
        ];

        $scope.medium = [
            {
                breed:"German Shepherd",
                image: "img/Gallery Images/german-shepherd-puppy.jpg"
            },
            {
                breed:"German Shepherd",
                image: "img/Gallery Images/shihtzu.jpg"
            },
            {
                breed:"Pomerinian",
                image: "img/Gallery Images/pomerinian.jpg"
            },
            {
                breed:"Retriever",
                image: "img/Gallery Images/retriever-2.jpg"
            },
            {

                breed: "Corgi",
                image: "img/Gallery Images/corgi-3.jpg"
            }
        ];

        $scope.large = [
            {
                breed: "French Bulldog",
                image: "img/Gallery Images/rugby-ipad-backgrounds-300x225.jpg"
            },
            {
                breed: "Corgi",
                image: "img/Gallery Images/100_0120.JPG"
            },
            {
                breed: "Corgi",
                image: "img/Gallery Images/100_0467.jpg"
            },
            {
                breed: "Corgi",
                image: "img/Gallery Images/100_0120.JPG"
            },
            {
                breed: "Corgi",
                image: "img/Gallery Images/100_0120.JPG"
            },
        ];

        function getRandomImage( photoArray ){
            return( photoArray[ getRan( 0, photoArray.length-1 ) ].image );
        }

        function getRan( min, max ){
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }

        function loadImages(){
            $scope.image[1] = getRandomImage($scope.small);
            $scope.image[2] = getRandomImage($scope.small);
            $scope.image[3] = getRandomImage($scope.medium);
            $scope.image[4] = getRandomImage($scope.large);
            $scope.image[5] = getRandomImage($scope.medium);
            $scope.image[6] = getRandomImage($scope.medium);
            $scope.image[7] = getRandomImage($scope.large);
        }

        function changeImgRan(){
            var index = getRan(1,6), ranImg;
            if ( index == 1 || index == 2 ) {
                ranImg = getRandomImage($scope.small);
            } else if ( index == 3 || index == 5 || index == 6 ) {
                ranImg = getRandomImage($scope.medium);
            } else if( index == 4 || index == 7){
                ranImg = getRandomImage($scope.large);
            }
            $scope.image[index] = ranImg;
        }

        loadImages();
        $interval( changeImgRan, 1500 );

    }]);

})();