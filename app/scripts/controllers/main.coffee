angular.module('idfBudgetApp').controller 'MainCtrl', ($scope, $location, $http) ->
    # Constants
    DEFAULT_ZONE = 15
    HOME_ZONE    = 15
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # Methods outside the scope
    # ──────────────────────────────────────────────────────────────────────────────────────────────   
    # Function that transforms raw data into a collection of objects
    csvToObject = (raw)->        
        # Parse CSV file         
        rows = CSV.parse(raw)
        if rows.length            
            # Remove the first line
            base = rows.shift()
            # Transform each row to an object
            rows = _.map rows, (r)-> _.object(base, r)        
    # Refresh active detail data
    refreshDetail = ()->        
        # Find the data related to this zone
        $scope.detail = _.findWhere $scope.details, id: $scope.activeZone if $scope.details?
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # Methods inside the scope
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # Update the current screen
    $scope.to = (screen='home')->
        $location.search "screen", screen       
    # Function to set the parent model value
    $scope.zone = (val=false)=>        
        # Only if we received a model attrbiute
        $scope.activeZone = val if val
        $scope.activeZone        
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # Scope attributes
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    $scope.details    = []
    $scope.activeZone = HOME_ZONE
    $scope.screen     = $location.search().screen or 'home'
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # XHR data loading
    # ──────────────────────────────────────────────────────────────────────────────────────────────    
    # Get all details
    $http.get('/data/details.csv').success (raw)-> 
        $scope.details = csvToObject(raw)
        refreshDetail()        
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # Watchers
    # ──────────────────────────────────────────────────────────────────────────────────────────────    
    # Watch for new selected zone
    $scope.$watch "activeZone", (val)-> refreshDetail()
    # Read the location's search to update the scope
    $scope.$on '$routeUpdate', =>
        $scope.screen = $location.search().screen or 'home'
        # Go to the begining of the landscape when we switch to detail
        $scope.zone(DEFAULT_ZONE) if $scope.screen is 'detail'        
        # Go to the middle of the landscape when we switch to home
        $scope.zone(HOME_ZONE) if $scope.screen is 'home'        