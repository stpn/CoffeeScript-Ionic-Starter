Number::map = (in_min, in_max, out_min, out_max) ->
  (this - in_min) * (out_max - out_min) / (in_max - in_min) + out_min


angular.module('starter.filters', []).filter 'buildingFilter', [ ->
  (models, activeBuilding) ->
    if !angular.isUndefined(models) and !angular.isUndefined(activeBuilding) and activeBuilding.length > 0
      tempClients = []
      angular.forEach models, (model) ->
        if angular.equals(model.building_name, activeBuilding)
          console.log(activeBuilding, model.building_name)
          tempClients.push model
      tempClients
    else
      models
 ]


angular.module('starter.directives',[]).directive 'clickSvg', [
  'ActiveBuilding'
  (activeBuilding) ->
    {
    scope: clickSvg: '='
    link: (scope, element, attrs) ->
      element.bind 'click', ->
        name = scope.clickSvg
        #activeBuilding.setName(name)
        #console.log "FUCK"
        #console.log '$eval type:', scope.clickSvg
        return
    }
]

# angular.module('starter.directives',[]).directive 'input', ($parse) ->
#   {
#     restrict: 'E'
#     require: '?ngModel'
#     link: (scope, element, attrs) ->
#       if attrs.ngModel and attrs.value
#         $parse(attrs.ngModel).assign scope, attrs.value
#       return

# }

angular.module('starter.directives',[]).directive 'backImg', ->
  (scope, element, attrs) ->
    attrs.$observe 'backImg', (value) ->
      element.css
        'background-image': 'url(' + value + ')'
        'background-size': 'cover'
      return
    return
    # }





angular.module('starter.directives',[]).directive 'ionPpinch', ($timeout) ->
  {
    restrict: 'E'
    link: ($scope, $element, attrs) ->
      if $element[0].classList[0] != "square"
        return      
      $timeout ->        
        square = $element[0]
        #console.log(square.getBoundingClientRect().left, square.getBoundingClientRect().right)
        posX = 0
        posY = 0
        lastPosX = 0
        lastPosY = 0
        bufferX = 0
        bufferY = 0
        scale = 1
        lastScale = undefined
        rotation = 0
        last_rotation = undefined
        dragReady = 0
        leftXLimit = 340
        rightXLimit = 1080
        fixPosXmin = 0
        fixPosXmax = 250
        lastMaxX = 0
        halt = false
        max = 200
        ionic.onGesture 'touch drag dragend transform', ((e) ->
          e.gesture.srcEvent.preventDefault()
          e.gesture.preventDefault()
          switch e.type
            when 'touch'
              lastScale = scale
#              last_rotation = rotation
            when 'drag'
              # if square.getBoundingClientRect().left > leftXLimit && square.getBoundingClientRect().right < rightXLimit 
              posX = e.gesture.deltaX/square.getBoundingClientRect().width * max + lastPosX
              lastMaxX = posX
              halt = false
              # else 
              #   if square.getBoundingClientRect().left == leftXLimit
              #     fixPosXmin = e.gesture.deltaX/square.getBoundingClientRect().width * max + lastPosX
              #   if square.getBoundingClientRect().left + square.getBoundingClientRect().width >= rightXLimit && halt == false
              #     fixPosXmax =  lastMaxX #e.gesture.deltaX/square.getBoundingClientRect().width * max + lastPosX
              #     halt = true
              # if fixPosXmin > e.gesture.deltaX/square.getBoundingClientRect().width * max + lastPosX
              #   posX = 2
              # if e.gesture.deltaX/square.getBoundingClientRect().width * max + lastPosX > fixPosXmax
              #   posX = 249
              if posX  > 249
                posX = 249
              if posX <= 1
                posX = 2
            when 'transform'
              #rotation = e.gesture.rotation + last_rotation
              scale = e.gesture.scale * lastScale
            when 'dragend'
              lastPosX = posX
              lastScale = scale
          transform = 'translate3d(' + posX + 'px, 0px, 0) ' + 'scale(' + scale + ')'  #+ 'rotate(' + rotation + 'deg) '
          e.target.style.transform = transform
          e.target.style.webkitTransform = transform

          # return
        ), $element[0]
      #   return
      # return

  }

# angular.module('starter.directives',[]).directive 'zoomIn', ->
#   {
#     restrict: 'A'
#     scope: false
#     #scope: curZoom: '='
#     link: (scope, ele, attr) ->
#       toZoom = document.getElementById(attr.zoomIn)      
#       ele.bind 'click', ->
#         scope.currentZoom = scope.currentZoom + 0.2
#         toZoom.style.transfrom = "scale("+scope.currentZoom+")"
#         toZoom.style.webkitTransform= "scale("+scope.currentZoom+")"
#         return
#       return

#   }
# angular.module('starter.directives',[]).directive 'click-svg', ->
#   {
#     scope: click-svg: '='
#     link: (scope, element, attrs) ->
#       element.bind 'click', ->
#         console.log '$eval type:', scope.createControl
#         return
#   }

# angular.module('starter.directives',[]).directive 'showData', ($compile) ->
#   {
#     scope: true
#     link: (scope, element, attrs) ->
#       el = undefined
#       attrs.$observe 'template', (tpl) ->
#         if angular.isDefined(tpl)
#           # compile the provided template against the current scope
#           el = $compile(tpl)(scope)
#           # stupid way of emptying the element
#           element.html ''
#           # add the template content
#           element.append el
#         return
#       return

#   }