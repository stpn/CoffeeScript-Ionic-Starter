angular.module('starter.filters', []).filter 'buildingFilter', [ ->
  (models, activeBuilding) ->
    if !angular.isUndefined(models) and !angular.isUndefined(activeBuilding) and activeBuilding.length > 0

      tempClients = []
      angular.forEach models, (model) ->
        if angular.equals(model.building_name, activeBuilding)
          tempClients.push model
      tempClients
    else
      models
 ]
angular.module('starter.directives',[]).directive 'clickMe', ($parse) ->
  # Runs during compile
  (scope, element, attrs) ->  
#  { link: ($scope, element, iAttrs, controller) ->
    element.bind 'click', ->
      console.log '$eval type:', scope.$eval(attrs.clickMe)
      type = $parse(attrs.clickMe)(scope)
      console.log '$parse type:', type
      return
    return

angular.module('starter.directives',[]).directive 'clickSvg', [
  'ActiveBuilding'
  (activeBuilding) ->
    {
    scope: clickSvg: '='
    link: (scope, element, attrs) ->
      element.bind 'click', ->
        name = scope.clickSvg
        activeBuilding.setName(name)
        console.log activeBuilding.getName()        
        # console.log '$eval type:', scope.clickSvg
        return
    }
]

angular.module('starter.directives',[]).directive 'backImg', ->
  (scope, element, attrs) ->
    attrs.$observe 'backImg', (value) ->
      element.css
        'background-image': 'url(' + value + ')'
        'background-size': 'cover'
      return
    return
    # }
angular.module('starter.directives',[]).directive 'ionPinch', ($timeout) ->
  {
    restrict: 'A'
    link: ($scope, $element) ->
      $timeout ->
        square = $element[0]
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
        ionic.onGesture 'touch drag transform dragend', ((e) ->
          e.gesture.srcEvent.preventDefault()
          e.gesture.preventDefault()
          switch e.type
            when 'touch'
              lastScale = scale
              last_rotation = rotation
            when 'drag'
              posX = e.gesture.deltaX + lastPosX
              posY = e.gesture.deltaY + lastPosY
            when 'transform'
              rotation = e.gesture.rotation + last_rotation
              scale = e.gesture.scale * lastScale
            when 'dragend'
              lastPosX = posX
              lastPosY = posY
              lastScale = scale
          transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' + 'scale(' + scale + ')' + 'rotate(' + rotation + 'deg) '
          e.target.style.transform = transform
          e.target.style.webkitTransform = transform
          return
        ), $element[0]
        return
      return

  }

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