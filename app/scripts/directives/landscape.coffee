angular.module('idfBudgetApp')
  .directive 'landscape', () ->
    restrict: 'A'
    scope:
      foreground    : "@"
      background    : "@"
      wrapper       : "@"
      listen        : "@"
      scrollDuration: "@"
    link: (scope, element, attrs) ->
      # Scroll to the given index or element 
      scrollTo = (index)->
        # Create the target selector
        selector = if angular.isNumber(index) then ".zone-#{index}" else index
        # Then scroll
        element.scrollTo selector, 
          duration: conf.scrollDuration
          # Center the scroll
          offset: -1 * ( $(window).width()/2 - $(selector).outerWidth()/2 )

      conf =
        # Targets elements of the landscape
        bg: angular.element scope.background or ".background"
        fg: angular.element scope.foreground or ".foreground"
        # Element that resize the wrapper
        wp: angular.element scope.wrapper
        # Velocity of the elements
        bgVelocity: 0.3
        fgVelocity: -0.8
        # Scroll duration
        scrollDuration: scope.scrollDuration or 600
      # We specified a wrapper referencial element
      if conf.wp
        # Wrap an element arround everything
        wrapper = $("<div />").css 
          width   : conf.wp.width()
          height  : conf.wp.height()
          overflow: "hidden"
          position: "relative"
        element.wrapInner wrapper
      # Watchs for scrolling into the landscape to update parallax
      element.on "scroll", ->
        offset = element.scrollLeft()
        # Moves elements
        conf.bg.css "left", offset * conf.bgVelocity
        conf.fg.css "left", offset * conf.fgVelocity      
      # Watch the given variable to scroll to the relevent element
      if scope.listen?
        # Scroll to the given element
        scope.$parent.$watch scope.listen, scrollTo
