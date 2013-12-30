angular.module('idfBudgetApp').controller 'MainCtrl', ($scope, $location) ->
    $scope.screen = $location.search().screen or 'home'
    # Read the location's search to update the scope
    $scope.$on '$routeUpdate', =>
        $scope.screen = $location.search().screen or 'home'
    # Update the current screen
    $scope.to = (screen='home')->
        $location.search "screen", screen