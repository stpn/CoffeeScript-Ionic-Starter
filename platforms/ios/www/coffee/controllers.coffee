angular.module('starter.controllers', []).controller('DashCtrl', ($scope, $q, $http, $rootScope,  $state,  $log, APIService, Renderings, Views, Floorplans, Videos, Webcams, Presentations, ActiveBuilding, TopmenuState, Buildings, Snapshots) -> 
  $scope.presentations = {}  
  $scope.factories = [["Presentations"], ["Videos"],  ["Floor Plans"], ["Renderings"], ["Views"]]
  $scope.snapshots = [["Webcams"]]

  # Renderings.sorted().then (reports) ->
  #   $scope.factories[3].push(reports)
  #   return

  angular.forEach [Presentations, Videos, Floorplans, Renderings, Views], (factory, index) ->
    console.log factory, index
    factory.sorted().then (reports) ->
      $scope.factories[index].push(reports)

  Snapshots.sorted().then (reports) ->
    $scope.snapshots[0].push(reports)
    return


  $scope.activeBuilding = ActiveBuilding
  $scope.activeBuildingName = undefined
  $scope.lastActiveName = undefined

  $scope.buldingTabName = "Select Buildings"
  
  $scope.activeComparison = undefined

  $scope.comparisonState = false
  # $scope.topMenu = TopmenuState.states

  $scope.buildings = Buildings.all()
  $scope.templatePath = "templates/menu/building_menu.html"
  $scope.compTemplate = "templates/menu/comparison_menu.html"
  $scope.bld_style="margin-top: -200px"
  $scope.transformStyle = "transform: scale(1.0)"

  $scope.clicker_default = "61px"
  $scope.clicker_narrow = "40px"
  $scope.clicker_extranarrow = "16px"
  $scope.clicker_padding = $scope.clicker_default
  $scope.accordionHeight = "0px"

  $scope.showOverlay = false

  $scope.assetToCompare = undefined
 

  $scope.isComparison = () ->    
    $scope.comparisonState

  $scope.isActiveBuilding =(name) ->
    if $scope.activeBuildingName == undefined
      return true
    $scope.activeBuildingName == name

  $scope.toggleGroup = (group) ->
    console.log $scope.activeBuildingName + " << ACTIVE BUILDING"
    menu = document.getElementById('ionTopMenu')
    if menu.style.height == '250px'
      $scope.toggleTopMenu()    
    #$log.debug($scope.activeBuilding.name, "NAME")
    #$log.debug("GROUP: ",$scope.activeBuilding.getName())
    if $scope.isGroupShown(group)
      $scope.shownGroup = null
      $scope.toggled = null
      $scope.clicker_padding = $scope.clicker_default
    else
      $scope.shownGroup = group
      $scope.toggled = true
      $scope.clicker_padding = $scope.clicker_extranarrow
    return

  $scope.isGroupShown = (group) ->

    $scope.shownGroup == group    

  $scope.groupHeight = (group) ->
    if $scope.isGroupShown(group) == true
      "153px"
    else
      "0px"

  $scope.isGroupClicked = (group) ->
    if $scope.isGroupShown(group)
      "603px"
    else
      ""
  

  $scope.cancelActiveBuilding = ($event) ->    
    bld_box = document.getElementById('building_menu_wrap')
    bld_box = bld_box.getBoundingClientRect()
    #$log.debug($event.clientX,$event.clientY, bld_box)
    #if $event.target.nodeName != "SVG" # != document.getElementById('bld1') && $event.target != document.getElementById('bld2') && $event.target != document.getElementById('bld3') && $event.target != document.getElementById('bld4') && $event.target != document.getElementById('bld5') 
    if $event.clientX > bld_box.left && $event.clientX < bld_box.right && $event.clientY > bld_box.top && $event.clientY < bld_box.bottom 
      return 
    else 
      #$log.debug($event.clientX, $scope.activeBuilding.name)
      $scope.setActiveBuilding(undefined)
      $scope.activeBuilding.cancelAll()


  $scope.building_is = (code, name) ->
    if code == name
      return true

  $scope.getTemplate = (name) ->
    Buildings.getTemplate(name)

  $scope.setActiveBuilding = (name)->
    # if name == undefined
    #   $scope.activeBuilding.tabName = "SELECT BUILDING"
    # else 
    if $scope.activeBuildingName == name
      name = undefined
    $scope.activeBuildingName = name
    $scope.buldingTabName = name

  
  $scope.buildingCode = (name)->    
    Buildings.buildingCode(name)


  $scope.toggleTopMenu  = (switchCompare)->
    was_comparison = false
    if $scope.comparisonState == true
      was_comparison = true
    $scope.comparisonState = false
    $scope.buldingTabName = $scope.activeBuildingName
    $scope.activeBuilding.tabName = $scope.lastActiveName
    bld = document.getElementById('building_wrap')
    menu = document.getElementById('ionTopMenu')
    pane = document.getElementsByTagName('ion-content')[0]
     
    if menu.offsetHeight == 24
      $scope.toggleGroup($scope.shownGroup)       
      menu.style.height = '250px' 
      $scope.clicker_padding = $scope.clicker_narrow
      pane.style.top = '320px'
    else 
      menu.style.height =  '24px' 
      if was_comparison == false
        $scope.clicker_padding = $scope.clicker_default
      pane.style.top = '70px'

    if menu.style.height == "24px"
      $scope.bld_style = "margin-top: -200px"
    else
      $scope.bld_style = "margin-top: 50px"
      

  $scope.showCompareMenu = (name, asset) ->    
    if name == "Presentations" || name == "Videos" || name == "Views"
      return
    if $scope.comparisonState == false
      $scope.assetToCompare = 
        asset: asset
        name: name
      $scope.comparisonState = true
      $scope.buldingTabName = "COMPARISON MODE"
      bld = document.getElementById('building_wrap')
      menu = document.getElementById('ionTopMenu')
      pane = document.getElementsByTagName('ion-content')[0]
    else
      $scope.comparisonState = false
      $scope.buldingTabName = $scope.activeBuildingName


    if menu.offsetHeight == 24 
      menu.style.height = '250px' 
    else 
      menu.style.height =  '24px' 
    if menu.style.height == "24px"
      $scope.bld_style = "margin-top: -200px"
    else
      $scope.bld_style = "margin-top: 50px"
   

  $scope.getFillColorFor = (bld_name) ->
    #console.log name, $scope.activeBuilding.getName() + " YESS"
    if $scope.activeBuildingName == undefined
      return "none"
    else if $scope.activeBuildingName == bld_name || $scope.activeBuildingName == "all"
      #console.log 'yess'
      return "#6D6F72"
    else 
      return "none"

  $scope.convertCode = (name) ->
    if name == "200M"
      return "M200"
    if name == "250M"
      return "M250"
    if name == "600"
      return "M600"
    if name == "201F"
      return "F201"
    if name == "200F"
      return "F200"


  $scope.setActiveComparison = (comparison) ->
    if comparison == $scope.activeComparison
      comparison = undefined
    $scope.activeComparison = comparison
    if comparison != "center"
      command =
        location: comparison
      APIService.control($scope.assetToCompare.asset, $scope.assetToCompare.name, command, "compare")
    else
      $scope.playAsset($scope.assetToCompare.name, $scope.assetToCompare.asset)
    $scope.toggleTopMenu()

  $scope.getComparisonStroke = (comparison) ->
    if comparison == $scope.activeComparison
      return "#FFF"
    else
      return "#808080"      

  $scope.playAsset = (name, asset) ->
    if name == "Presentations"
      $scope.openLoc('presentations', asset.id)
      return
    # else if name == "Views"
    #   $scope.openLoc('views', asset.id)
    #   return
    else if name == "Videos"
      $scope.openLoc('videos', asset.id)
      return      
    else
      APIService.control(asset, name, {}, "play")


  $scope.openLoc = (location, modId) ->  
    $state.go('tab.'+location, id : modId, {});
    # window.location = '#/tab/'+location+'/' + modId
    # window.location.reload()
    return

).controller('titleCtrl', ($scope, $stateParams) ->
  $scope.titleTemplate = "templates/menu/title.html"
  $scope.home = '#/tab/home'
  $scope.dash = "#/tab/dash"
  $scope.buildings ="#/tab/buildings"

  return


).controller('FloorplanDetailCtrl', ($scope, $stateParams, Floorplans) ->
  $scope.floorplan = Floorplans.get($stateParams.id)
  return


).controller('WebcamsCtrl', ($scope, $state, $log, Webcams, Timelapses) ->
  $scope.activeWebcam = undefined
  $scope.nowLive = false
  $scope.nowLive4 = false
  $scope.activeWebcamId = undefined



  Webcams.all().then (reports) ->
    $scope.webcams = reports
    return  

  $scope.noPano = ->
    if $scope.activeWebcam
      if $scope.activeWebcam.panoramas_count == 0
        return true
    else
      return true

  $scope.viewPano = ->
    if $scope.activeWebcam
      if $scope.activeWebcam.panoramas_count == 0
        return 1
      else
        $state.go('tab.panoramas', ({cameraId : $scope.activeWebcamId}) );

  # $scope.panoramas = undefined
  # $scope.timelapses = undefined

  $scope.isActive = (item) ->
    if $scope.activeWebcam == undefined
      false
    else if $scope.activeWebcam.id == item.id
      true
    else
      false

  $scope.getZoom = () ->
    $scope.currentZoom

  $scope.setZoom = (val) ->
    $scope.currentZoom = val


  $scope.setActiveWebcam = (activeWebcam) ->   
    $scope.activeWebcamId = activeWebcam.id
    $scope.activeWebcam = Webcams.getLocal($scope.activeWebcamId)    
    $scope.nowLive = false
    $scope.nowLive4 = false
    $scope.nowPano = false
    Timelapses.getForCamera($scope.activeWebcamId).then (timelapses) ->
      $scope.timelapses = timelapses

    $log.debug($scope.panoramas)

  $scope.isEnabled = (model) ->
    model == undefined

  $scope.getActiveWebcam = (activeWebcam) ->
    $scope.activeWebcam    

  $scope.isLive = ->
    $scope.nowLive

  $scope.setLive = ->
    $scope.nowLive = !$scope.nowLive
    $scope.resetEverything()
    $scope.nowLive4 = false
    $state.go("tab.live",{},{})

  $scope.setLive4 = ->
    $scope.nowLive4 = !$scope.nowLive4
    $scope.resetEverything()
    $scope.nowLive = false

  
  $scope.resetEverything = ->
    $scope.activeWebcam = undefined
    $scope.activeWebcamId = undefined
    $scope.timelapses = undefined
    $scope.shownGroup = null    

  $scope.isLive4 = ->
    $scope.nowLive4

  $scope.isPano = ->
    $scope.nowPano

  $scope.setPano = ->
    $scope.nowPano = true


  $scope.toggleGroup = (group) ->
    if $scope.isGroupShown(group)
      $scope.shownGroup = null
      $scope.accordionHeight = "0px"
    else
      $scope.shownGroup = group
      $scope.accordionHeight = "593px"
    return

  $scope.isGroupShown = (group) ->
    $scope.shownGroup == group       
  return


).controller('PresentationCtrl', ($scope,$log, $stateParams, $timeout, $interval, Presentations, APIService) ->
  #$scope.presentation = Presentations.get($stateParams.id)
  #$scope.slides = Presentations.getSlides($stateParams.id)
  promise = undefined
  $scope.play = true
  $scope.videoPlaying = false
  
  $scope.currentSlide = 1

  
  Presentations.get($stateParams.id).then (result) ->
    $scope.presentation = result
    $scope.slides = $scope.presentation.slides
    $scope.presentation_name = $scope.presentation.name
    $scope.project_name = $scope.presentation.building_name
    $scope.slide = $scope.presentation.slides[0]
    $scope.postSlide(1)
    
    

  $scope.playFirstSlide = () ->
    if $scope.slides[0].slideable_type == "Video"
      $scope.playVideoSlide()
    else
      $scope.start_playing()
      $scope.playImageSlide()
      


  $scope.playVideoSlide = () ->
    slideable = 
      id: $scope.slide.slideable_id
    APIService.control(slideable, $scope.slide.slideable_type+"s", {}, "play")  
    $scope.videoPlaying = true  
#    console.log 'playing Video'    
    $timeout (->
      $scope.videoPlaying = false
      $scope.start_playing()
      return
    ), $scope.slide.image.duration * 1000 + 1000    

  $scope.playImageSlide = () ->
    $scope.stop_playing()
    slideable = 
      id: $scope.slide.slideable_id
    APIService.control(slideable, $scope.slide.slideable_type+"s", {}, "play")    
#    console.log 'playing Video'    

  $scope.postSlide = (slideIdx) ->
    if slideIdx > $scope.slides.length 
      $scope.currentSlide = 1  
    else if slideIdx <= 1
      $scope.currentSlide = 1
    else
      $scope.currentSlide = slideIdx
    $scope.slide = $scope.presentation.slides[$scope.currentSlide - 1]
    if $scope.slide.slideable_type == "Video"
      $scope.stop_playing()
      $scope.playVideoSlide()
    else
      $scope.playImageSlide()

  $scope.start_playing = () ->
    $scope.play = !$scope.play
    if $scope.play      
      promise = $interval($scope.advanceSlide, 5000)
      console.log "STARTED"
    else 
      $scope.stop_playing()
      console.log "STOPPED"

  $scope.stop_playing = () ->
    if $scope.slide.slideable_type == "Video" && $scope.videoPlaying == true
      console.log $scope.slide
      slideable = 
        id: $scope.slide.slideable_id      
      APIService.control(slideable, $scope.slide.slideable_type+"s", {}, "pause")
      $scope.videoPlaying = false
    $interval.cancel(promise)

  $scope.advanceSlide = () ->
    if $scope.play
      $scope.postSlide($scope.currentSlide + 1)
      
  $scope.$on '$destroy', ->
    $interval.cancel(promise)
    return



# ).controller('VideoPlayerCtrl', ($scope, $sce, $log, $stateParams, Videos) ->
#   $scope.video = Videos.get($stateParams.id)
#   #$log.debug($scope.video.recording);

#   $scope.recording = $sce.trustAsResourceUrl($scope.video.recording.url)

#   $scope.building_name = $scope.video.building_name 
  
#   $scope.trustSrc = (src) ->
#     $scope.videos = $sce.getTrustedResourceUrl(src);

#   $scope.postVideoId = (videoId) ->
#     $log.debug("....  "+ videoId)
  
#   $scope.alertMe = ()->
#     $log.debug("...")    
#   return


).controller('BuildingsCtrl', ($scope, Buildings, $log, ActiveCrestron) ->
  $scope.buildings = Buildings.all()
  $scope.templatePath = "templates/menu/building_menu.html"
  $scope.transformStyle = "scale(1.19)"
  $scope.activeBuilding = ActiveCrestron

  $scope.getTemplate = (name) ->
    Buildings.getTemplate(name)

  $scope.building_is = (code, name) ->
    if code == name
    # if name == "200 Mass"
      return true

  $scope.buildingCode = (name)->    
    Buildings.buildingCode(name)


  $scope.setActiveBuilding = (name)->
    if name == "all"
      if $scope.activeBuilding.isActive("all")
        $scope.activeBuilding.cancelAll()
        $scope.activeBuilding.setName("all")
      else
        $scope.activeBuilding.setAll()        
    else 
      if $scope.activeBuilding.isActive("all")
        $scope.activeBuilding.setName("all")

    $scope.activeBuilding.setName(name)
    $scope.activeBuilding.tabName = name


  $scope.getFillColorFor = (bld_name) ->
    #console.log name, $scope.activeBuilding.getName() + " YESS"
    if $scope.activeBuilding == undefined
      return "none"
    else if $scope.activeBuilding.getName(bld_name)
      #console.log 'yess'
      return "#6D6F72"
    else 
      return "none"



  # $scope.getFillColorFor = (bld) ->
  #   if bld == "all" == $scope.activeBuilding.getName()
  #     return "#6D6F72"
  #   #console.log name, $scope.activeBuilding.getName() + " YESS"
  #   else if $scope.activeBuilding == undefined
  #     return "none"
  #   else if bld.name == $scope.activeBuilding.getName()
  #     #console.log 'yess'
  #     return "#6D6F72"
  #   else 
  #     return "none"

  $scope.convertCode = (name) ->
    if name == "200M"
      return "M200"
    if name == "250M"
      return "M250"
    if name == "600"
      return "M600"
    if name == "201F"
      return "F201"
    if name == "200F"
      return "F200"


  return





).controller('PanoramasCtrl', ($scope, $stateParams, Panoramas, ActiveCamera, $ionicHistory) ->
  
  #$scope.webcam_name = Panoramas.getWebcamName($stateParams.id)
  #console.log $scope.panorama.image
  $scope.currentZoom = 1.0
  $scope.factoryName = "Panoramas"
  square = document.getElementById("square")
  posX = 0
  posY = 0
  pan =  document.getElementById("panorama_image")
  firstWidth = square.getBoundingClientRect().width
  firstHeight = square.getBoundingClientRect().height

  deltaHeight = 0
  deltaWidth = 0


  Panoramas.get_by_camera($stateParams.cameraId).then (result) ->
    $scope.panorama = result
    $scope.webcam_name = $scope.panorama.webcam_name
    $scope.image_url = $scope.panorama.image.url
    img = new Image()
    img.src = $scope.panorama.image.url
    $scope.dimensions = {}
    $scope.dimensions.width = img.width
    $scope.dimensions.height = img.height


  changeScale = () ->
    scaleToSend = parseFloat(1.0)
    if parseFloat($scope.currentZoom) > parseFloat(1.0)
      scaleToSend = parseFloat(parseFloat($scope.currentZoom) - 1)
    else if  parseFloat($scope.currentZoom) < parseFloat(1.0)
      scaleToSend = parseFloat(parseFloat($scope.currentZoom) + 1)
    
    console.log "NEW SCALE: ", parseFloat(scaleToSend)
    console.log "OLD SCALE: ", parseFloat($scope.currentZoom)
    scaleToSend    

  $scope.zoomIn = (name) ->
    console.log $scope.currentZoom
    if $scope.currentZoom <= 0.4 
      return             
    toZoom = document.getElementById(name)
    $scope.currentZoom = $scope.currentZoom - 0.2
    toZoom.style.transfrom = "scale("+$scope.currentZoom+")"
    toZoom.style.webkitTransform= "scale("+$scope.currentZoom+")"

    changeScale()

  $scope.zoomOut = (name) ->
    console.log $scope.currentZoom 
    if $scope.currentZoom >= 1.0 
      return
    else if $scope.currentZoom <= 0.3
      return

    toZoom = document.getElementById(name)
    $scope.currentZoom = $scope.currentZoom + 0.2
    # toZoom.style.transfrom = "scale("+$scope.currentZoom+")"
    # toZoom.style.webkitTransform= "scale("+$scope.currentZoom+")"

    deltaWidth = Math.abs(square.getBoundingClientRect().width - firstWidth)
    deltaHeight = Math.abs(square.getBoundingClientRect().height - firstHeight)                          
    transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' +  " " + "scale("+$scope.currentZoom+")"
    toZoom.style.transform = transform 
    toZoom.style.webkitTransform = toZoom.style.transform
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
      console.log 'CHANGING: '+ posX +  " " + posY
      transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) '+  " " + "scale("+$scope.currentZoom+")"
      toZoom.style.transform = transform  
      toZoom.style.webkitTransform = toZoom.style.transform      
      angular.element(toZoom).trigger("transformend")        
      # square.style.left = String(posX + "px")
      changeX = false
      changeY = false  
    # if changeY  == true
    #   #square.style.top = String(posY + "px")
    #   transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' +  " " + "scale("+$scope.currentZoom+")"
    #   toZoom.style.transform = transform
    #   toZoom.style.webkitTransform = toZoom.style.transform                
    #   changeY = false  

    changeScale()

  $scope.getPanorama =  ->
    $scope.panorama.image

  $scope.getCamera =  ->
    1

).controller('VideoCtrl', ($scope, $sce, $log, $state, $stateParams, Videos, $location, APIService) ->
  $scope.videoDiv = document.getElementById('video')
  $scope.seekBar = document.getElementById('seekbar')
  $scope.volume = document.getElementById('volume')
  $scope.viedeo
  $scope.skipValue = 0
  $scope.mute = false
  $scope.max = 80
  $scope.videoState = true

  Videos.get($stateParams.id).then (result) ->
    $scope.video = result
    #console.log $scope.video.recording.url, "URL"
    $scope.recording = $sce.trustAsResourceUrl($scope.video.recording.url)

    $scope.videoDiv.innerHTML = '<source src="'+$scope.recording+'"type="video/mp4"/>'   

    $scope.building_name = $scope.video.building_name     
    #$scope.videoPlay(false)
    APIService.control($scope.video, "Videos", {}, "play")
  
  $scope.trustSrc = (src) ->
    $scope.videos = $sce.getTrustedResourceUrl(src);

  $scope.videoDiv.addEventListener 'timeupdate', ->
    #console.log $scope.videoDiv.currentTime, $scope.videoDiv.duration
    # never calls
    value = (100 / $scope.videoDiv.duration) * $scope.videoDiv.currentTime;
    if !value
      value = 0
    $scope.seekBar.value = value
    return
  
  $scope.closeBtn =() ->
    $scope.videoDiv.pause()
    APIService.control($scope.video, "Videos", {}, "stop")
    $state.go('tab.dash', {}, {});

  $scope.update = ->
    $scope.videoDiv.pause()

  $scope.seekRelease = ->
    currentTime = $scope.seekBar.value / (100 / $scope.videoDiv.duration)
    #console.log currentTime, " CURRENT TIME"
    $scope.videoDiv.currentTime = currentTime
    command = 
      seekto: currentTime
    APIService.control($scope.video, "Videos", command, "cue")

    if $scope.videoState
      $scope.videoDiv.play(false)

  $scope.volumeUp = ->
    #console.log 'UP'
    if $scope.volume.value < 100
      $scope.volume.value = $scope.volume.value + 5
    else
      $scope.volume.value = 100

  $scope.volumeDown = ->
    #console.log 'DOWN'
    if $scope.volume.value > 0 
      $scope.volume.value = $scope.volume.value - 5
    else
      $scope.volume.value = 0    


  $scope.videoBack =  ->
    $scope.videoDiv.currentTime = 0
    command = 
      seekto: $scope.videoDiv.currentTime
    APIService.control($scope.video, "Videos", command, "cue")    


  $scope.videoBw =  ->
    $scope.videoDiv.currentTime = $scope.videoDiv.currentTime - 5
    command = 
      seekto: $scope.videoDiv.currentTime
    APIService.control($scope.video, "Videos", command, "cue")


  $scope.videoFw =  ->
    $scope.videoDiv.currentTime = $scope.videoDiv.currentTime + 5
    command = 
      seekto: $scope.videoDiv.currentTime
    APIService.control($scope.video, "Videos", command, "cue")


  $scope.videoPlay = (remote_also = true)  ->
    if $scope.videoDiv.paused 
      $scope.videoDiv.play()
      APIService.control($scope.video, "Videos", {}, "unpause")
      $scope.videoState = true
    else
      $scope.videoDiv.pause()
      APIService.control($scope.video, "Videos", {}, "pause")
      $scope.videoState = false


  $scope.isMute = ->
    $scope.mute

  $scope.setMute = ->
    $scope.mute = !$scope.mute

  $scope.progressRelease = ($event) ->
    if $event.gesture.deltaX > 0          
      if $scope.volume.value >= 100
        $scope.volume.value = 100
      else
        $scope.volume.value = $scope.volume.value + 5/$scope.volume.getBoundingClientRect().width * $scope.max
      #$scope.volumeUp()
    else
      if $scope.volume.value <= 0
        $scope.volume.value = 0
      else
        $scope.volume.value = $scope.volume.value - 5/$scope.volume.getBoundingClientRect().width * $scope.max


  # $scope.$on '$destroy', ->
  #   APIService.control($scope.video, "Videos", {}, "stop")
  #   return
 
  # Timelapses.get($stateParams.id).then (result) ->
  #   $scope.video = result
  #   console.log $scope.video.recording.url, "URL"
  #   $scope.recording = $sce.trustAsResourceUrl($scope.video.recording.url)
  #   $scope.building_name = $scope.video.building_name 



  # $scope.video = Timelapses.getLocal($stateParams.id)
  # console.log $scope.video.recording.url, "URL"
  # $scope.recording = $sce.trustAsResourceUrl($scope.video.recording.url)
  # $scope.building_name = $scope.video.building_name 



  return

).controller('TimelapsesCtrl', ($scope, $sce, $log,  $stateParams, Timelapses, $location, APIService) ->

  $scope.videoDiv = document.getElementById('video')
  $scope.seekBar = document.getElementById('seekbar')
  $scope.volume = document.getElementById('volume')
  $scope.viedeo
  $scope.skipValue = 0
  $scope.mute = false
  $scope.max = 80
  $scope.videoState = true

  # Videos.get($stateParams.id).then (result) ->
  #   $scope.video = result
  #   #console.log $scope.video.recording.url, "URL"
  #   $scope.recording = $sce.trustAsResourceUrl($scope.video.recording.url)

  #   $scope.videoDiv.innerHTML = '<source src="'+$scope.recording+'"type="video/mp4"/>'   

  #   $scope.building_name = $scope.video.building_name     
  #   #$scope.videoPlay(false)
  #   APIService.control($scope.video, "Videos", {}, "play")
#  Timelapses.get($stateParams.id).then (result) ->
  $scope.video = Timelapses.getLocal($stateParams.id)  
  $scope.recording = $sce.trustAsResourceUrl($scope.video.recording.url)
  $scope.building_name = $scope.video.camera_name 
  APIService.control($scope.video, "Timelapses", {}, "play")

  
  $scope.trustSrc = (src) ->
    $scope.videos = $sce.getTrustedResourceUrl(src);

  $scope.videoDiv.addEventListener 'timeupdate', ->
    #console.log $scope.videoDiv.currentTime, $scope.videoDiv.duration
    # never calls
    value = (100 / $scope.videoDiv.duration) * $scope.videoDiv.currentTime;
    if !value
      value = 0
    $scope.seekBar.value = value
    return
  
  $scope.closeBtn =() ->
    $scope.videoDiv.pause()
    APIService.control($scope.video, "Videos", {}, "stop")
    $state.go('tab.dash', {}, {});

  $scope.update = ->
    $scope.videoDiv.pause()

  $scope.seekRelease = ->
    currentTime = $scope.seekBar.value / (100 / $scope.videoDiv.duration)
    #console.log currentTime, " CURRENT TIME"
    $scope.videoDiv.currentTime = currentTime
    command = 
      seekto: currentTime
    APIService.control($scope.video, "Videos", command, "cue")

    if $scope.videoState
      $scope.videoDiv.play(false)

  $scope.volumeUp = ->
    #console.log 'UP'
    if $scope.volume.value < 100
      $scope.volume.value = $scope.volume.value + 5
    else
      $scope.volume.value = 100

  $scope.volumeDown = ->
    #console.log 'DOWN'
    if $scope.volume.value > 0 
      $scope.volume.value = $scope.volume.value - 5
    else
      $scope.volume.value = 0    


  $scope.videoBack =  ->
    $scope.videoDiv.currentTime = 0
    command = 
      seekto: $scope.videoDiv.currentTime
    APIService.control($scope.video, "Timelapses", command, "cue")    


  $scope.videoBw =  ->
    $scope.videoDiv.currentTime = $scope.videoDiv.currentTime - 5
    command = 
      seekto: $scope.videoDiv.currentTime
    APIService.control($scope.video, "Timelapses", command, "cue")


  $scope.videoFw =  ->
    $scope.videoDiv.currentTime = $scope.videoDiv.currentTime + 5
    command = 
      seekto: $scope.videoDiv.currentTime
    APIService.control($scope.video, "Timelapses", command, "cue")


  $scope.videoPlay = (remote_also = true)  ->
    if $scope.videoDiv.paused 
      $scope.videoDiv.play()
      APIService.control($scope.video, "Timelapses", {}, "unpause")
      $scope.videoState = true
    else
      $scope.videoDiv.pause()
      APIService.control($scope.video, "Timelapses", {}, "pause")
      $scope.videoState = false


  $scope.isMute = ->
    $scope.mute

  $scope.setMute = ->
    $scope.mute = !$scope.mute

  $scope.progressRelease = ($event) ->
    if $event.gesture.deltaX > 0          
      if $scope.volume.value >= 100
        $scope.volume.value = 100
      else
        $scope.volume.value = $scope.volume.value + 5/$scope.volume.getBoundingClientRect().width * $scope.max
      #$scope.volumeUp()
    else
      if $scope.volume.value <= 0
        $scope.volume.value = 0
      else
        $scope.volume.value = $scope.volume.value - 5/$scope.volume.getBoundingClientRect().width * $scope.max

#   $scope.videoDiv = document.getElementById('video')
#   $scope.seekBar = document.getElementById('seekbar')
#   $scope.volume = document.getElementById('volume')
#   $scope.skipValue = 0
#   $scope.mute = false
#   $scope.max = 80
#   $scope.videoState = true

#   # Timelapses.get($stateParams.id).then (result) ->
#   #   $scope.video = result
#   #   console.log $scope.video.recording.url, "URL"
#   #   $scope.recording = $sce.trustAsResourceUrl($scope.video.recording.url)
#   #   $scope.building_name = $scope.video.building_name 


# #  Timelapses.get($stateParams.id).then (result) ->
#   $scope.video = Timelapses.getLocal($stateParams.id)
#   console.log $scope.video.recording.url, "URL"
#   $scope.recording = $sce.trustAsResourceUrl($scope.video.recording.url)
#   $scope.building_name = $scope.video.building_name 

  
#   $scope.trustSrc = (src) ->
#     $scope.videos = $sce.getTrustedResourceUrl(src);

#   $scope.postVideoId = (videoId) ->  

#   $scope.videoDiv.addEventListener 'timeupdate', ->
#     # console.log 'test'
#     # never calls
#     value = (100 / $scope.videoDiv.duration) * $scope.videoDiv.currentTime;
#     #console.log value
#     $scope.seekBar.value = value
#     return
#   $scope.closeBtn =() ->
#     $scope.videoDiv.pause()
#     $location.path('#/dash/')

#   $scope.update = ->
#     $scope.videoDiv.pause()

#   $scope.seekRelease = ->
#     currentTime = $scope.seekBar.value / (100 / $scope.videoDiv.duration);
#     $scope.videoDiv.currentTime = currentTime;
#     if $scope.videoState
#       $scope.videoDiv.play()

#   $scope.volumeUp = ->
#     #console.log 'UP'
#     if $scope.volume.value < 100
#       $scope.volume.value = $scope.volume.value + 5
#     else
#       $scope.volume.value = 100

#   $scope.volumeDown = ->
#     #console.log 'DOWN'
#     if $scope.volume.value > 0 
#       $scope.volume.value = $scope.volume.value - 5
#     else
#       $scope.volume.value = 0    


#   $scope.videoBack =  ->
#     $scope.videoDiv.currentTime = 0

#   $scope.videoBw =  ->
#     $scope.videoDiv.currentTime = $scope.videoDiv.currentTime - 5

#   $scope.videoFw =  ->
#     $scope.videoDiv.currentTime = $scope.videoDiv.currentTime + 5

#   $scope.videoPlay =  ->
#     if $scope.videoDiv.paused
#       $scope.videoDiv.play()
#       $scope.videoState = true
#     else
#       $scope.videoDiv.pause()
#       $scope.videoState = false

#   $scope.isMute = ->
#     $scope.mute

#   $scope.setMute = ->
#     $scope.mute = !$scope.mute

#   $scope.progressRelease = ($event) ->
#     if $event.gesture.deltaX > 0          
#       if $scope.volume.value >= 100
#         $scope.volume.value = 100
#       else
#         $scope.volume.value = $scope.volume.value + 5/$scope.volume.getBoundingClientRect().width * $scope.max
#       #$scope.volumeUp()
#     else
#       if $scope.volume.value <= 0
#         $scope.volume.value = 0
#       else
#         $scope.volume.value = $scope.volume.value - 5/$scope.volume.getBoundingClientRect().width * $scope.max


).controller('LiveCtrl', ($scope) ->
  $scope.arrow_template = "templates/webcams/arrow.html"
  return   

).controller('HomeCtrl', ($scope) ->
  $scope.home = "HOME"
  return   

).controller('ResetCtrl', ($scope, $ionicHistory) ->
  
  $scope.goBack = ->
    window.history.back();
    
  $scope.go = (path) ->
    $location.path(path)


  return 


).controller 'ViewsCtrl', ($scope, $stateParams, Views, ActiveCamera, $ionicHistory) ->
  $scope.currentZoom = 1.0
  square = document.getElementById("square")
  posX = 0
  posY = 0
  pan =  document.getElementById("panorama_image")
  firstWidth = square.getBoundingClientRect().width
  firstHeight = square.getBoundingClientRect().height
  $scope.factoryName = "Views"

  Views.get($stateParams.id).then (result) ->
    
    $scope.view = result
    $scope.building_name = $scope.view.building_name 
    $scope.imageUrl = $scope.view.image.url


  $scope.zoomIn = (name) ->
    console.log $scope.currentZoom
    if $scope.currentZoom <= 0.4 
      return             
    toZoom = document.getElementById(name)
    $scope.currentZoom = $scope.currentZoom - 0.2
    toZoom.style.transfrom = "scale("+$scope.currentZoom+")"
    toZoom.style.webkitTransform= "scale("+$scope.currentZoom+")"

    scaleToSend = 1
    if parseFloat($scope.currentZoom) > 1
      scaleToSend = parseFloat($scope.currentZoom) - 1
    else if  parseFloat($scope.currentZoom) > 1
      scaleToSend = parseFloat($scope.currentZoom) + 1
    
    console.log "NEW SCALE: ", parseFloat(scaleToSend)
    console.log "OLD SCALE: ", parseFloat($scope.currentZoom)


  $scope.zoomOut = (name) ->

    console.log $scope.currentZoom 
    if $scope.currentZoom >= 1.0 
      return
    toZoom = document.getElementById(name)
    $scope.currentZoom = $scope.currentZoom + 0.2
    # toZoom.style.transfrom = "scale("+$scope.currentZoom+")"
    # toZoom.style.webkitTransform= "scale("+$scope.currentZoom+")"

    deltaWidth = Math.abs(square.getBoundingClientRect().width - firstWidth)
    deltaHeight = Math.abs(square.getBoundingClientRect().height - firstHeight)                          
    transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' +  " " + "scale("+$scope.currentZoom+")"
    toZoom.style.transform = transform 
    toZoom.style.webkitTransform = toZoom.style.transform
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
      transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) '+  " " + "scale("+$scope.currentZoom+")"
      toZoom.style.transform = transform  
      toZoom.style.webkitTransform = toZoom.style.transform              
      # square.style.left = String(posX + "px")
      changeX = false
      changeY = false  
    # if changeY  == true
    #   #square.style.top = String(posY + "px")
    #   transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' +  " " + "scale("+$scope.currentZoom+")"
    #   toZoom.style.transform = transform
    #   toZoom.style.webkitTransform = toZoom.style.transform                
    #   changeY = false  

    # scaleToSend = 1
    # if parseFloat($scope.currentZoom) > 1
    #   scaleToSend = parseFloat($scope.currentZoom) - 1
    # else if  parseFloat($scope.currentZoom) > 1
    #   scaleToSend = parseFloat($scope.currentZoom) + 1
    
    # console.log "NEW SCALE: ", parseFloat(scaleToSend)
    # console.log "OLD SCALE: ", parseFloat($scope.currentZoom)



  $scope.getView =  ->
    $scope.view.image

  $scope.getCamera =  ->
    1


# generated by js2coffee 2.1.0