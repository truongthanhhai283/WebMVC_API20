/// <reference path="../plugins/angular/angular.js" />

var myApp = angular.module('myModule', []);

myApp.controller("schoolController", schoolController);
myApp.service('Validator', Validator);

myApp.directive("shopOnlineDirective", shopOnlineDirective);


schoolController.$inject = ['$scope', 'Validator'];

function schoolController($scope, Validator) {

    $scope.checkNumber = function () {
        $scope.message = Validator.checkNumber($scope.num);
    }
    $scope.num = 1;
}

function Validator($window) {
    return {
        checkNumber: checkNumber
    }
    function checkNumber(input) {
        if (input % 2 == 0) {
            return 'This is even';
        }
        else
            return 'This is odd';
    }

}

function shopOnlineDirective() {
    return {
        //template: "<h1>This is my first custom directive </h1>",

        //gioi han pham vi hoat dong "A": attribute
        restrict:"A",
        templateUrl: "/Scripts/spa/ShopOnlineDirective.html"
    }
}