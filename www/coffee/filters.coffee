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


angular.module('starter.directives',[]).directive 'backImg', ->
  (scope, element, attrs) ->
    attrs.$observe 'backImg', (value) ->
      element.css
        'background-image': 'url(' + value + ')'
        'background-size': 'cover'
      return
    return


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
              if changeX ==true || changeY  == true
                transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) '+  " " + match[0]
                e.target.style.transform = transform  
                e.target.style.webkitTransform = e.target.style.transform              
                # square.style.left = String(posX + "px")
                changeX = false
              # if changeY  == true
              #   #square.style.top = String(posY + "px")
              #   transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' +  " " + match[0]
              #   e.target.style.transform = transform
              #   e.target.style.webkitTransform = e.target.style.transform                
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
              if changeX ==true || changeY  == true
                transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) '+  " " + 'scale(' + scale + ')'
                e.target.style.transform = transform  
                e.target.style.webkitTransform = e.target.style.transform              
                # square.style.left = String(posX + "px")
                changeX = false
              # if changeY  == true
              #   #square.style.top = String(posY + "px")
              #   transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' +  " " + 'scale(' + scale + ')'
              #   e.target.style.transform = transform
              #   e.target.style.webkitTransform = e.target.style.transform                
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
