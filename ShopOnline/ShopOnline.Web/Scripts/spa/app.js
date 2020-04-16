/// <reference path="../plugins/angular/angular.js" />

//Khởi tạo module
var myapp = angular.module("myModule", []);

//Gọi controller
myapp.controller("teacherController", teacherController);
myapp.controller("studentController", studentController);
myapp.controller("schoolController", schoolController);

myController.$inject = [$scope]

//Khai báo controller
function myController($scope) {
    $scope.message = "This's my message from Controller";
}

function teacherController($scope) {
    $scope.message = "This's my message from teacherController";
}

function studentController($scope) {
    $scope.message = "This's my message from studentController";
}

function schoolController($scope) {
    $scope.message = "Announcement from school";
}