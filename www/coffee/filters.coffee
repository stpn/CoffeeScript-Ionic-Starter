Number::map = (in_min, in_max, out_min, out_max) ->
  (this - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

scaleValues = (posY, posX, scale, img, imgname) ->

  w = 676
  h = 190

  scaleToSend = 1/scale

  xToSend = -(posX - 46).map(0, w , -0.25 ,1.25   )
  yToSend = 0
  if scale != 0  
    xToSend = -(posX - 46).map(0, w , -(scaleToSend*0.75-0.5), (scaleToSend * 0.75 + 0.5) ) 
    yToSend = (posY - 178).map(0,h ,-(scaleToSend*0.5 - 0.5), scaleToSend*0.5 +0.5)


  # console.log "POS TO ORIGINAL "+ posX + " " + posY
  # console.log "CUR POS : "+  posX + " " + posY
  # console.log "TOUCH OLD SCALE: ", parseFloat(scale)              
  # console.log "TOUCH NEW SCALE: ", parseFloat(scaleToSend)
  # console.log "POS TO SEND "+ xToSend + " " + yToSend

  command = 
    x: xToSend
    y: yToSend
    z: scaleToSend

  command


angular.module('starter.filters', []).filter 'buildingFilter', [ ->
  (models, activeBuilding) ->
  
    if !angular.isUndefined(models) and !angular.isUndefined(activeBuilding) and activeBuilding.length > 0
      tempClients = []
      angular.forEach models, (model) ->
        if angular.equals(model.building_name, activeBuilding) || angular.equals(activeBuilding, "all")
          #console.log(activeBuilding, model.building_name)
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

angular.module('starter.directives',[]).directive 'zoomOut', ->
  {
    restrict: 'E'
    template: '<div class ="zoom_out" ng-click=clickFunc() >
                -
            </div>'
    link: (scope) ->

      scope.clickFunc = ->
        alert 'Hello, world!'
        return

      return

  }


angular.module('starter.directives',[]).directive 'ionPpinch', ($timeout, APIService) ->
  {
    restrict: 'E'
    scope: 
      image: '='          
      imgname: '='
      dimensions: '='
    link: ($scope, $element, attrs) ->
      if $element[0].classList[0] != "square"
        return      
      $timeout ->        
        pan = document.getElementById("panorama_image")
        console.log $scope.image, $scope.imgname
        square = $element[0]
        firstWidth = square.getBoundingClientRect().width
        firstHeight = square.getBoundingClientRect().height
        #console.log(square.getBoundingClientRect().left, square.getBoundingClientRect().right)
        posX = 0
        posY = 0
        lastPosX = 0
        lastPosY = 0
        scale = 1
        lastScale = undefined
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
        changeX = false
        changeY = false
        deltaHeight = 0
        deltaWidth = 0

        cur_dim =
          width: 676
          height: 186
        orig_dim = $scope.dimensions

        ionic.onGesture 'touch drag dragend transform release transformend', ((e) ->
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
                changeY = false                              

            when 'transform'

              scale = e.gesture.scale * lastScale
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
                changeX = false
                changeY = false     


            when 'dragend'
              lastPosX = posX
              lastPosY = posY
              lastScale = scale
                
            when 'release'
              command = scaleValues(square.getBoundingClientRect().top, square.getBoundingClientRect().left, scale, $scope.image, $scope.imgname)
              APIService.control($scope.image, $scope.imgname, command, "pano")      

            when 'transformend'
              command = scaleValues(square.getBoundingClientRect().top, square.getBoundingClientRect().left, scale, $scope.image, $scope.imgname)
              APIService.control($scope.image, $scope.imgname, command, "pano")      


        ), $element[0]
      #   return
      # return

  }
