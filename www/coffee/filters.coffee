Number::map = (in_min, in_max, out_min, out_max) ->
  (this - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
#If your number X falls between A and B, and you would like Y to fall between C and D, you can apply the following linear transform:
#Y = (X-A)/(B-A) * (D-C) + C

scaleValues = (posY, posX, scale, img, imgname) ->
  pano_big = 11532
  screen = 7680
  width_ratio =  1.5015625 

  scaleToSend = parseFloat(1.0)
  if parseFloat(scale) > parseFloat(1.0)
    scaleToSend = parseFloat(parseFloat(scale) - 1)
  else if  parseFloat(scale) < parseFloat(1.0)
    scaleToSend = parseFloat(parseFloat(scale) + 1)
  #xToSend = 0
  #if posX != 0
  # xToSend = -(posX - 46).map(0,676,0, 11532) #+ 676/2 #+11532*scale/6  
  xToSend = -(posX - 46).map(0,676,-0.2,1.2) #+ 676/2 #+11532*scale/6  


  #yToSend = 0
  console.log "POS TO ORIGINAL "+ posX + " " + posY
  #if posY > Math.abs(32)
  #yToSend = -(posY - 178).map(0,186,0, 3240)# + 186/2  #+3240*scale/6           
  yToSend = (posY - 178).map(0,186,0, 1)# + 186/2  #+3240*scale/6           


  console.log "TOUCH OLD SCALE: ", parseFloat(scale)              
  console.log "TOUCH NEW SCALE: ", parseFloat(scaleToSend)
  console.log "POS TO SEND "+ xToSend + " " + yToSend

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

        cur_dim =
          width: 676
          height: 186
        orig_dim = $scope.dimensions

        ionic.onGesture 'touch drag dragend transform release', ((e) ->
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

              command = scaleValues(square.getBoundingClientRect().top, square.getBoundingClientRect().left, scale, $scope.image, $scope.imgname)
              APIService.panorama($scope.image, $scope.imgname, command)      
   

            when 'dragend'
              lastPosX = posX
              lastPosY = posY
              lastScale = scale
                
              # console.log ("^^^^ DRAGGING ")

              # xToSend = -posX.map(0,cur_dim.width,0, $scope.dimensions.width)+$scope.dimensions.width/6
              # yToSend = -posY.map(0,cur_dim.height,0, $scope.dimensions.height)#+$scope.dimensions.height/           

              # scaleToSend = parseFloat(1.0)
              # if parseFloat(scale) > parseFloat(1.0)
              #   scaleToSend = parseFloat(parseFloat(scale) - 1)
              # else if  parseFloat(scale) < parseFloat(1.0)
              #   scaleToSend = parseFloat(parseFloat(scale) + 1)
              
              
              # console.log "OLD DRAG SCALE: ", parseFloat(scale)              
              # console.log "NEW DRAG SCALE: ", parseFloat(scaleToSend)


              # command = 
              #   x: xToSend
              #   y: yToSend
              #   z: scaleToSend
              # APIService.panorama($scope.image, $scope.imgname, command)              

            when 'release'
              command = scaleValues(square.getBoundingClientRect().top, square.getBoundingClientRect().left, scale, $scope.image, $scope.imgname)
              APIService.panorama($scope.image, $scope.imgname, command)      

              # yToSend = -posY.map(0,186,0, 3240)#+3240/6           

              # console.log "DIM "+ $scope.dimensions.width + " " + posY

              
              # scaleToSend = parseFloat(1.0)
              # if parseFloat(scale) > parseFloat(1.0)
              #   scaleToSend = parseFloat(parseFloat(scale) - 1)
              # else if  parseFloat(scale) < parseFloat(1.0)
              #   scaleToSend = parseFloat(parseFloat(scale) + 1)

              # #WORKS NOW
              # xToSend = -posX.map(0,676,0, 11532)+11532*Math.abs(scaleToSend)/6
              
              # console.log "POS TO SEND "+ xToSend + " " + yToSend
              # console.log "TOUCH OLD SCALE: ", parseFloat(scale)              
              # console.log "TOUCH NEW SCALE: ", parseFloat(scaleToSend)


              # command = 
              #   x: xToSend
              #   y: yToSend
              #   z: scaleToSend
              # APIService.panorama($scope.image, $scope.imgname, command)   


              
              # xToSend = -posX.map(0,cur_dim.width,0, $scope.dimensions.width)+$scope.dimensions.width/6
              # yToSend = -posY.map(0,cur_dim.height,0, $scope.dimensions.height)+$scope.dimensions.height/6           


              # scaleToSend = parseFloat(1.0)
              # if parseFloat(scale) > parseFloat(1.0)
              #   scaleToSend = parseFloat(parseFloat(scale) - 1)
              # else if  parseFloat(scale) < parseFloat(1.0)
              #   scaleToSend = parseFloat(parseFloat(scale) + 1)
              
              
              # console.log "OLD SCALE: ", parseFloat(scale)              
              # console.log "NEW SCALE: ", parseFloat(scaleToSend)


              # command = 
              #   x: xToSend
              #   y: yToSend
              #   z: scaleToSend
              # APIService.panorama($scope.image, $scope.imgname, command)
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
