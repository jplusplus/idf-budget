angular.module('idfBudgetApp').directive 'bound', () ->
    restrict: 'A'
    link: (scope, element, attributes)->
        # ──────────────────────────────────────────────────────────────────────────────────────────
        # Directive values
        # ──────────────────────────────────────────────────────────────────────────────────────────
        # Get the parent element
        parent = element.parents(attributes.parent or window)
        width  = parent.outerWidth()
        height = parent.outerHeight()
        # Step size
        step   = attributes.step
        offset = 1*(attributes.offset or 0)
        # Get the coordonates of the final point
        to     = attributes.bound.split(";")
        # Non-optional attribute
        return unless to.length == 2
        to     = left: 1*to[0], top: 1*to[1]
        # ──────────────────────────────────────────────────────────────────────────────────────────
        # Drawing helpers
        # ──────────────────────────────────────────────────────────────────────────────────────────
        # Function that returns the points interpolated
        pointsFn = d3.svg.line()
                    .x( (d)-> d.x )
                    .y( (d)-> d.y )
                    .interpolate("linear")
        # Update the point
        draw = -> path.attr("d", pointsFn getPoints() )
        # Points that compose the bound.
        # We deduce them using 'to' and 'from'.
        getPoints = ->
            # Get the coordonates of the origin point;
            # we use the parent offset to have more precise data
            from   = element.offset()
            from   =
                left: from.left - parent.offset().left + offset
                top : from.top  - parent.offset().top + element.outerHeight()/2
            unless step
                # Compute the step size if need
                step = (from.left - to.left) * 0.5
            # Reverse step according the direction of the bound
            if from.left < to.left and step > 0 then step *= -1
            # Returns the 4 points of the path
            return [
                { x: from.left, y: from.top }
                { x: from.left - step, y: from.top }
                { x: from.left - step, y: to.top }
                { x: to.left, y: to.top }
            ]
        # ──────────────────────────────────────────────────────────────────────────────────────────
        # Drawing the bound
        # ──────────────────────────────────────────────────────────────────────────────────────────
        # We append an SVG to the parent
        vis = d3.select(parent[0])
                    .append("svg")
                        .attr("class", "js-bound-draw ")
                        .style("position", "absolute")
                        .style("top", 0)
                        .style("left", 0)
                        # This new svg has the same size than the parent
                        .attr("width", "#{width}px")
                        .attr("height", "#{height}px")
        # Draw the bound inside the svg
        path = vis.append("path")
                    .attr("stroke", "#586063")
                    .attr("stroke-width", 1)
                    .attr("fill", "none")
        # Show and hide the element
        element.hover ->
            # Draws the point with updated coordonates
            draw()
            # Removes hidden class
            vis.attr("class", "js-bound-draw")
        , ->
            # Restores hidden class
            vis.attr("class", "js-bound-draw hidden")