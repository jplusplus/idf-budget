angular.module('idfBudgetApp').controller 'MainCtrl', ($scope, $location, $http) ->
    # Constants
    DEFAULT_ZONE = 1
    HOME_ZONE    = 8
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
    refreshDetail = ->        
        # Find the data related to this zone
        $scope.detail = $scope.details[$scope.activeZone-1] if $scope.details?
    # Read location argument to update the screen
    readLocation = ->        
        $scope.screen = $location.search().screen or 'home'
        switch $scope.screen 
            # Go to the begining of the landscape when we switch to detail
            when 'detail' then $scope.zone(DEFAULT_ZONE)      
            # Go to the middle of the landscape when we switch to home
            when 'home' then $scope.zone(HOME_ZONE)
        switch $scope.screen 
            # Scroll down to global
            when 'global' then $(window).scrollTo(top: 250, left:0, 600)
            else $(window).scrollTo(top: 0, left:0, 600)
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
    $scope.screen     = 'home'
    # Read the location by default
    readLocation()
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # XHR data loading
    # ──────────────────────────────────────────────────────────────────────────────────────────────    
    # Get all details
    $http.get('/data/details.csv').success (raw)->         
        # Parses and sorts data by id
        $scope.details = _.sortBy csvToObject(raw), (d)-> d.id
        # Then refresh the active detail
        refreshDetail()        
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # Watchers
    # ──────────────────────────────────────────────────────────────────────────────────────────────    
    # Watch for new selected zone
    $scope.$watch "activeZone", refreshDetail
    # Read the location's search to update the scope
    $scope.$on '$routeUpdate', readLocation