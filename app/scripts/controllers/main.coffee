angular.module('idfBudgetApp').controller 'MainCtrl', ($scope, $location, $http, $rootElement) ->
    # Constants
    DEFAULT_ZONE = 1
    HOME_ZONE    = 8
    # Parent frame
    FRAME        = $rootElement.find(".main")
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
        # Are we coming from the homepage?
        wasHome = $scope.screen is 'home'
        # Read the new name
        $scope.screen = $location.search().screen or 'home'
        # Go to the begining of the landscape when we switch to detail
        if $scope.screen is 'detail' and wasHome then $scope.zone(DEFAULT_ZONE)
        # Scroll down to global
        if $scope.screen is 'global' then FRAME.scrollTo(top: 250, left:0, 600)
        # Or reset the scroll
        else FRAME.scrollTo(0, 600)
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
    # Get all exemples
    $http.get('/data/exemples.csv').success (raw)->
        # Parses data
        $scope.exemples = csvToObject(raw)
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # Watchers
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # Watch for new selected zone
    $scope.$watch "activeZone", refreshDetail
    # Read the location's search to update the scope
    $scope.$on '$routeUpdate', readLocation