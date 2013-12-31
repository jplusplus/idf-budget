angular.module('idfBudgetApp', [
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ng-iscroll'
]).config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
      reloadOnSearch: no
    .otherwise
      redirectTo: '/'
