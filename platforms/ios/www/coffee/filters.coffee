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





# angular.module('starter.directives',[]).directive 'ionPpinch', ($timeout) ->
#   {
#     restrict: 'E'
#     link: ($scope, $element, attrs) ->
#       if $element[0].classList[0] != "square"
#         return      
#       $timeout ->        
#         pan = document.getElementById("panorama_image")

#         square = $element[0]
#         firstWidth = square.getBoundingClientRect().width
#         #console.log(square.getBoundingClientRect().left, square.getBoundingClientRect().right)
#         posX = 0
#         posY = 0
#         lastPosX = 0
#         lastPosY = 0
#         bufferX = 0
#         bufferY = 0
#         scale = 1
#         lastScale = undefined
#         rotation = 0
#         last_rotation = undefined
#         dragReady = 0
#         leftXLimit = 44
#         rightXLimit = 720
#         topYLimit = 197
#         bottomYLimit = 390    
#         lastMaxX = 0
#         lastMinX = 0
#         lastMaxY = 0
#         lastMinY = 0
#         max = 200
#         oldScale = 0
#         oldWidth = 0
#         pass = false
#         changed = false
#         deltaWidth = 0
#         ionic.onGesture 'touch drag dragend transform', ((e) ->
#           e.gesture.srcEvent.preventDefault()
#           e.gesture.preventDefault()

#           scalRgxp = /scale\((\d{1,}\.\d{1,})\)/
#           match = e.target.style.transform.match(scalRgxp)
#           if !match
#             match = [""]
#           else
#             if oldScale != match[1]
#               LastMinX = undefined              
#               oldScale = match[1]

#               deltaWidth = Math.abs(square.getBoundingClientRect().width - firstWidth)
#           switch e.type
#             when 'touch'
#               lastScale = scale
# #              last_rotation = rotation
#             when 'drag'
#               #if square.getBoundingClientRect().left > leftXLimit  && square.getBoundingClientRect().top > topYLimit && square.getBoundingClientRect().right < rightXLimit && square.getBoundingClientRect().bottom < bottomYLimit  
#               if square.getBoundingClientRect().left > pan.getBoundingClientRect().left - 1  && square.getBoundingClientRect().top > pan.getBoundingClientRect().top - 1 && square.getBoundingClientRect().right < pan.getBoundingClientRect().right + 1 && square.getBoundingClientRect().bottom < pan.getBoundingClientRect().bottom + 1
#                 posX = e.gesture.deltaX/square.getBoundingClientRect().width * max + lastPosX
#                 # if match[1]
#                 #   posX = (e.gesture.deltaX/square.getBoundingClientRect().width * max + lastPosX) * match[1]
#                 posY = e.gesture.deltaY/square.getBoundingClientRect().height * max + lastPosY         
#                 if deltaWidth != 0
#                   lastMinX = posX - deltaWidth
#                 console.log deltaWidth, "DELTA"

#                 if posX <= lastMinX
#                   console.log posX, lastMinX, "ADJUSTED"
#                   posX = lastMinX
#                 if posX > lastMaxX && lastMaxX > 0
#                   posX = lastMaxX 
#                 if posY < lastMinY
#                   posY = lastMinY
#                 if posY > lastMaxY && lastMaxY > 0
#                   posY = lastMaxY 
#                 oldWidth = square.getBoundingClientRect().width
#                 # if oldWidth > 0
#                 #   deltaWidth = Math.abs(square.getBoundingClientRect().width - oldWidth)
#                 #   console.log deltaWidth, oldWidth
#                 #   lastMinX = lastMinX - deltaWidth  
#                 #   pass = true                              
#                 #console.log square.getBoundingClientRect().top, " < TOP", square.getBoundingClientRect().left, " <LEFT", posX, " < posX", lastMinX , " <LastMinX"                                      
#               else 
#                 if square.getBoundingClientRect().left < pan.getBoundingClientRect().left - 1   
#                   lastPosX = lastPosX + 1
#                   if deltaWidth != 0
#                     lastPosX = lastPosX  - deltaWidth 
#                     deltaWidth = 0
#                 # else
#                   console.log "LastMinX: ", lastMinX, " LastPosX: " ,lastPosX, " posX: " , posX, " deltaWidth: " , deltaWidth
#                   lastMinX = lastPosX 
#                   posX = lastMinX    
#                   #console.log "AFTER ", lastMinX           
#                 if square.getBoundingClientRect().right > pan.getBoundingClientRect().right + 1              
#                   lastPosX = posX - 1
#                   lastMaxX = lastPosX
#                   posX = lastMaxX
#                 if square.getBoundingClientRect().top < pan.getBoundingClientRect().top - 1  

#                   lastMinY = lastPosY + 1
#                   lastMinY = lastPosY
#                 if square.getBoundingClientRect().bottom > pan.getBoundingClientRect().bottom + 1              
#                   lastPosY = posY - 1
#                   lastMaxY = lastPosY
#                   posY = lastMaxY

#             when 'transform'
#               #rotation = e.gesture.rotation + last_rotation
#               scale = e.gesture.scale * lastScale
#               lastMaxX = 0
#               lastMinX = undefined
#               lastMaxY = 0
#              # lastMinY = 0              
#             when 'dragend'
#               lastPosX = posX
#               lastPosY = posY
#               lastScale = scale
#           #   lastMaxX = 0
#           #   lastMinX = 0
#           #   lastMaxY = 0
#           #   lastMinY = 0     
#           transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' #+ 'scale(' + scale + ')'  #+ 'rotate(' + rotation + 'deg) '
#           # e.target.style.height = String(e.target.offsetHeight * scale)+"px"
#           # e.target.style.width = String(e.target.offsetWidth * scale)+"px"
#           e.target.style.transform = transform +  " " + match[0]
#           e.target.style.webkitTransform = e.target.style.transform + " " + match[0]

#           # return
#         ), $element[0]
#       #   return
#       # return

#   }
angular.module('starter.directives',[]).directive 'ionPpinch', ($timeout) ->
  {
    restrict: 'E'
    link: ($scope, $element, attrs) ->
      if $element[0].classList[0] != "square"
        return      
      $timeout ->        
        pan = document.getElementById("panorama_image")
        
        square = $element[0]
        firstWidth = square.getBoundingClientRect().width
        firstHeight = square.getBoundingClientRect().height
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
        topYLimit = 204
        bottomYLimit = 390    
        lastMaxX = 0
        lastMinX = 0
        lastMaxY = 0
        lastMinY = 0
        max = 200
        oldScale = 0
        oldWidth = 0
        pass = false
        changeX = false
        changeY = false
        deltaHeight = 0
        deltaWidth = 0
        scaleChange = false
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
              console.log "TOUCH"
            when 'drag'
              console.log "DRAG"
              posX = e.gesture.deltaX/square.getBoundingClientRect().width * max  + lastPosX
              posY = e.gesture.deltaY/square.getBoundingClientRect().height * max + lastPosY 

              deltaWidth = Math.abs(square.getBoundingClientRect().width - firstWidth)
              deltaHeight = Math.abs(square.getBoundingClientRect().height - firstHeight)                          
              transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' +  " " + match[0]              
              e.target.style.transform = transform 
              e.target.style.webkitTransform = e.target.style.transform
              if square.getBoundingClientRect().left <= pan.getBoundingClientRect().left
                posX =  -deltaWidth  / 2
                changeX = true
              if square.getBoundingClientRect().top <= pan.getBoundingClientRect().top
                posY = -deltaHeight  / 2
                changeY = true
              if square.getBoundingClientRect().right >= pan.getBoundingClientRect().right
                posX = pan.offsetWidth - square.getBoundingClientRect().width - deltaWidth  / 2
                changeX = true
              if square.getBoundingClientRect().bottom >= pan.getBoundingClientRect().bottom
                posY = pan.offsetHeight - square.getBoundingClientRect().height - deltaHeight  / 2
                changeY = true  
              if changeX ==true
                transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) '+  " " + match[0]
                e.target.style.transform = transform  
                e.target.style.webkitTransform = e.target.style.transform              
                # square.style.left = String(posX + "px")
                changeX = false
              if changeY  == true
                #square.style.top = String(posY + "px")
                transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' +  " " + match[0]
                e.target.style.transform = transform
                e.target.style.webkitTransform = e.target.style.transform                
                changeY = false                              

            when 'transform'

              scale = e.gesture.scale * lastScale
              if scale  != lastScale
                scaleChange = true
              if scale > 1 
                scale = 1
              deltaWidth = Math.abs(square.getBoundingClientRect().width - firstWidth)
              deltaHeight = Math.abs(square.getBoundingClientRect().height - firstHeight)                          
              transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' +  " " + 'scale(' + scale + ')'
              e.target.style.transform = transform 
              e.target.style.webkitTransform = e.target.style.transform
              if square.getBoundingClientRect().left <= pan.getBoundingClientRect().left
                posX =  -deltaWidth  / 2
                changeX = true
              if square.getBoundingClientRect().top <= pan.getBoundingClientRect().top
                posY = -deltaHeight  / 2
                changeY = true
              if square.getBoundingClientRect().right >= pan.getBoundingClientRect().right
                posX = pan.offsetWidth - square.getBoundingClientRect().width - deltaWidth  / 2
                changeX = true
              if square.getBoundingClientRect().bottom >= pan.getBoundingClientRect().bottom
                posY = pan.offsetHeight - square.getBoundingClientRect().height - deltaHeight  / 2
                changeY = true  
              if changeX ==true
                transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) '+  " " + 'scale(' + scale + ')'
                e.target.style.transform = transform  
                e.target.style.webkitTransform = e.target.style.transform              
                # square.style.left = String(posX + "px")
                changeX = false
              if changeY  == true
                #square.style.top = String(posY + "px")
                transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' +  " " + 'scale(' + scale + ')'
                e.target.style.transform = transform
                e.target.style.webkitTransform = e.target.style.transform                
                changeY = false     

            when 'dragend'
              lastPosX = posX
              lastPosY = posY
              lastScale = scale
          #   lastMaxX = 0
          #   lastMinX = 0
          #   lastMaxY = 0
          #   lastMinY = 0   


          # if scaleChange  
          #   transform = transform + 'scale(' + scale + ')'  #+ 'rotate(' + rotation + 'deg) '
          #   e.target.style.transform = transform# +  " " + match[0]
          #   e.target.style.webkitTransform = e.target.style.transform #+ " " + match[0]
          #   scaleChange = false

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