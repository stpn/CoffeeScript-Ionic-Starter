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
        leftXLimit = 44
        rightXLimit = 720
        topYLimit = 197
        bottomYLimit = 385     
        lastMaxX = 0
        lastMinX = undefined
        lastMaxY = 0
        lastMinY = 0
        max = 200
        oldScale = 0
        ionic.onGesture 'touch drag dragend transform', ((e) ->
          e.gesture.srcEvent.preventDefault()
          e.gesture.preventDefault()

          scalRgxp = /scale\((\d{1,}\.\d{1,})\)/
          match = e.target.style.transform.match(scalRgxp)
          if !match
            match = [""]
          else
            if oldScale != match[1]
              LastMinX = undefined
              oldScale = match[1]

          switch e.type
            when 'touch'
              lastScale = scale
#              last_rotation = rotation
            when 'drag'
              if square.getBoundingClientRect().left > leftXLimit  && square.getBoundingClientRect().top > topYLimit && square.getBoundingClientRect().bottom < bottomYLimit  && square.getBoundingClientRect().right < rightXLimit 
                posX = e.gesture.deltaX/square.getBoundingClientRect().width * max + lastPosX
                posY = e.gesture.deltaY/square.getBoundingClientRect().height * max + lastPosY   
                if lastMinX != undefined
                  if posX < lastMinX
                    posX = lastMinX
                if posX > lastMaxX && lastMaxX > 0
                  posX = lastMaxX 
                if posY < lastMinY
                  posY = lastMinY
                if posY > lastMaxY && lastMaxY > 0
                  posY = lastMaxY 
                console.log square.getBoundingClientRect().top, " < TOP", square.getBoundingClientRect().left, " <LEFT", posX, " < posX", lastMinX , " <LastMinX"                                      
              else 
                if square.getBoundingClientRect().left <= leftXLimit   
                  #console.log "HERE ", lastMinX, lastPosX           
                  lastPosX = lastPosX + 1
                  lastMinX = lastPosX 
                  posX = lastMinX    
                  console.log "AFTER ", lastMinX           
                if square.getBoundingClientRect().right > rightXLimit              
                  lastPosX = posX - 1
                  lastMaxX = lastPosX
                  posX = lastMaxX
                if square.getBoundingClientRect().top < topYLimit  

                  lastMinY = lastPosY + 1
                  lastMinY = lastPosY
                if square.getBoundingClientRect().bottom > bottomYLimit              
                  lastPosY = posY - 1
                  lastMaxY = lastPosY
                  posY = lastMaxY

            when 'transform'
              #rotation = e.gesture.rotation + last_rotation
              scale = e.gesture.scale * lastScale
              lastMaxX = 0
              lastMinX = undefined
              lastMaxY = 0
             # lastMinY = 0              
            when 'dragend'
              lastPosX = posX
              lastPosY = posY
              lastScale = scale
          #   lastMaxX = 0
          #   lastMinX = 0
          #   lastMaxY = 0
          #   lastMinY = 0     
          transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' #+ 'scale(' + scale + ')'  #+ 'rotate(' + rotation + 'deg) '
          # e.target.style.height = String(e.target.offsetHeight * scale)+"px"
          # e.target.style.width = String(e.target.offsetWidth * scale)+"px"
          e.target.style.transform = transform +  " " + match[0]
          e.target.style.webkitTransform = e.target.style.transform + " " + match[0]

          # return
        ), $element[0]
      #   return
      # return

  }

angular.module('starter.directives',[]).directive 'ionPpinchh', ($timeout) ->
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
        leftXLimit = 0
        rightXLimit = 720
        topYLimit = 197
        bottomYLimit = 385     
        lastMaxX = 0
        lastMinX = undefined
        lastMaxY = 0
        lastMinY = 0
        max = 200
        oldScale = 0

        # obj = new Object
        # e = event.target
        # # just make it shorter because we use it everywhere
        # obj.element = e
        # # parentNode is our bounding box
        # # the minimum boundary is based on the top left corner of our container
        # obj.minBoundX = e.parentNode.offsetLeft
        # obj.minBoundY = e.parentNode.offsetTop
        # # the maximum is the bottom right corner of the container
        # # or.. the top left (x,y) + the height and width (h,y) - the size of the square
        # obj.maxBoundX = obj.minBoundX + e.parentNode.offsetWidth - (e.offsetWidth)
        # obj.maxBoundY = obj.minBoundY + e.parentNode.offsetHeight - (e.offsetHeight)
        # obj.posX = event.clientX - (e.offsetLeft)
        # obj.posY = event.clientY - (e.offsetTop)
        # minBox = document.getElementById('min')
        # minBox.style.left = obj.minBoundX + 'px'
        # minBox.style.top = obj.minBoundY + 'px'
        # maxBox = document.getElementById('max')
        # maxBox.style.left = obj.maxBoundX + 'px'
        # maxBox.style.top = obj.maxBoundY + 'px'
        # dragObj = obj

# READ HOW HE CREATES EVENTS

        ionic.onGesture 'touch drag dragend transform', ((e) ->
          e.gesture.srcEvent.preventDefault()
          e.gesture.preventDefault()


          switch e.type
            when 'touch'
              lastScale = scale
#              last_rotation = rotation
            when 'drag'
              posX = e.gesture.deltaX + lastPosX
              # if posX < leftXLimit
              #  posX = leftXLimit
              # dragObj.element.style.left = Math.max(dragObj.minBoundX, Math.min(event.clientX - dragObj.posX, dragObj.maxBoundX)) + "px";
              # dragObj.element.style.top = Math.max(dragObj.minBoundY, Math.min(event.clientY - dragObj.posY, dragObj.maxBoundY)) + "px";       
            when 'transform'
              #rotation = e.gesture.rotation + last_rotation
              scale = e.gesture.scale * lastScale
 
            when 'dragend'
              lastScale = scale
              lastPosX = posX
          square.style.left = String(posX)+"px"
          curTransform = new   WebKitCSSMatrix(window.getComputedStyle(e.target).webkitTransform)
          realLeft = e.target.offsetLeft + curTransform.m41
          #http://stackoverflow.com/questions/13882070/jquery-draggable-and-webkit-transform-scale
          #http://cerdiogenes.blogspot.com.br/2015/01/jquery-ui-draggable-reseizable-with.html

          if realLeft <= document.getElementById("panorama_image").getBoundingClientRect().left
            #console.log e.target.getBoundingClientRect().left, document.getElementById("panorama_image").getBoundingClientRect().left
            e.target.style.left = String(document.getElementById("panorama_image").getBoundingClientRect().left)+"px"
          # transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' #+ 'scale(' + scale + ')'  #+ 'rotate(' + rotation + 'deg) '
          # # e.target.style.height = String(e.target.offsetHeight * scale)+"px"
          # # e.target.style.width = String(e.target.offsetWidth * scale)+"px"
          # e.target.style.transform = transform +  " " + match[0]
          # e.target.style.webkitTransform = e.target.style.transform + " " + match[0]

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