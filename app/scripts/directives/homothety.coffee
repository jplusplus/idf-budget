angular.module('idfBudgetApp').directive 'homothety', ($window)->
    restrict: 'A'
    link: (scope, element, attrs)->
        ###*
        * Scale the size of the element
        * @return {Number} Scale applied to the element
        ###
        resize = ->
            scale = Math.min 1, wdw.width() / maxWidth
            # Allow the parent iframe to fits with this element
            body.css "min-height", element.height() * scale
            element.css "transform", "scale(#{scale})"
            scale
        # Use initial with as max width
        maxWidth = element.outerWidth()
        # jQuery shortcuts
        wdw      = angular.element $window
        body     = angular.element "body"
        # Trigger rescaling when the windows is resized
        wdw.on "resize", resize
        do resize

