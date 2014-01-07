angular.module('idfBudgetApp').controller 'MainCtrl', ($scope, $location, $http, $rootElement) ->
    # Constants
    DEFAULT_ZONE = 1
    HOME_ZONE    = '.home-center'
    # Parent frame
    FRAME        = $rootElement.find(".scrollable")
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
    
    ephemeralClass = (what=$rootElement, cls='fade', duration=700, callback=->)->
        what.addClass cls
        # Remove the class after a short delay
        setTimeout -> 
            what.removeClass cls
            callback()
            # Refresh the scope
            $scope.$apply()
        , 700

    # Refresh active detail data
    refreshDetail = ->
        # Fade animation on .js-title
        #ephemeralClass $rootElement.find(".js-fade"), 'do-fade', 700, ->
        # Find the data related to this zone
        $scope.detail = $scope.details[$scope.activeZone-1] if $scope.details?
    # Read location argument to update the screen
    readLocation = ->
        # Are we coming from the homepage?
        wasHome = $scope.screen is 'home'
        # Read the new name
        $scope.screen = $location.search().screen or 'home'
        # Go back to the center of the homepage
        if $scope.screen is 'home' then $scope.zone(HOME_ZONE)
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
    $scope.to = (screen='home')-> $location.search "screen", screen
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
    $http.get('/data/exemples.csv').success (raw)-> $scope.exemples = csvToObject(raw)
    # Get budget composition
    $http.get('/data/budget.csv').success (raw)-> $scope.budget = csvToObject(raw)
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # Watchers
    # ──────────────────────────────────────────────────────────────────────────────────────────────
    # Watch for new selected zone
    $scope.$watch "activeZone", refreshDetail
    # Read the location's search to update the scope
    $scope.$on '$routeUpdate', readLocation