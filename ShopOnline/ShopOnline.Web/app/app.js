/// <reference path="../assets/admin/libs/angular/angular.js" />

   //khai báo app có module shoponline (chính), ['shoponline.products', 'shoponline.common']
(function () {
    angular.module('shoponline', ['shoponline.products', 'shoponline.common']).config(config);

    //inject vào 2 thứ $stateProvider, $urlRouterProvider
    config.$inject = ['$stateProvider', '$urlRouterProvider'];

    //Cấu hình routing
    function config($stateProvider, $urlRouterProvider) {
        //tên state = home
        $stateProvider.state('home', {

            //Tham số 1 (url)
            url: "/admin",

            //Tham số 2 (templateUrl)
            templateUrl: "/app/components/home/homeView.html",

            //tên controller
            controller: "homeController"
        });

        //Nếu không phải trường hợp nào thì trả về admin
        $urlRouterProvider.otherwise('/admin');
    }
})();