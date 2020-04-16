/// <reference path="../plugins/angular/angular.js" />

//Khởi tạo module
var myapp = angular.module("myModule", []);

//Gọi controller
myapp.controller("myController", myController);

myController.$inject = [$scope]

//Khai báo controller
function myController($scope) {
    $scope.message = "This's my message from Controller";
}