angular.module('starter.controllers', []).controller('DashCtrl', ($scope, $rootScope,  $state,  $log, Renderings, Views, Floorplans, Videos, Webcams, Presentations, ActiveBuilding, TopmenuState, Buildings) -> 
  $scope.presentations = {}
  #$scope.factories = [["Presentations", Presentations.all()], ["Videos", Videos.all()],  ["Floor Plans", Floorplans.all()], ["Rendering", Renderings.all()], ["Views", Views.all()],  ["Webcams", Webcams.all()]]
  # [["Presentation"], [models]] 
  $scope.factories = [["Presentations", Presentations.sorted()], ["Videos", Videos.sorted()],  ["Floor Plans", Floorplans.sorted()], ["Rendering", Renderings.sorted()], ["Views", Views.sorted()],  ["Webcams", Webcams.sorted()]]
  $scope.activeBuilding = ActiveBuilding

  $scope.buldingTabName = "Select Buildings"
  
  $scope.comparisonState = false
  # $scope.topMenu = TopmenuState.states

  $scope.buildings = Buildings.all()
  $scope.templatePath = "templates/menu/building_menu.html"
  $scope.compTemplate = "templates/menu/comparison_menu.html"
  $scope.bld_style="margin-top: -200px"
  $scope.transformStyle = "transform: scale(1.0)"

  $scope.clicker_default = "63px"
  $scope.clicker_narrow = "43px"
  $scope.clicker_extranarrow = "17px"
  $scope.clicker_padding = $scope.clicker_default
  $scope.accordionHeight = "0px"

  $scope.showOverlay = false

  # $scope.isBuildings = () ->
  #   TopmenuState.getBuildings()

  # $scope.isComparison = () ->    
  #   TopmenuState.getComparison()

  $scope.isComparison = () ->    
    $scope.comparisonState


  $scope.isActive =(name) ->
    $scope.activeBuilding.isActive(name)

  $scope.toggleGroup = (group) ->
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
  
  
  $scope.openPres = (presId) ->
    window.location = '#/tab/presentations/' + presId
    window.location.reload()
    return

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

    # $scope.activeBuilding.name = undefined
    # $log.debug($scope.activeBuilding)
  
  $scope.activeBuildingTabName = ->
    if $scope.activeBuilding.name == undefined 
      "SELECT BUILDING"
    else 
      $scope.activeBuilding.name

  $scope.building_is = (code, name) ->
    if code == name
    # if name == "200 Mass"
      return true

  $scope.getTemplate = (name) ->
    Buildings.getTemplate(name)

  $scope.setActiveBuilding = (name)->
    if name == undefined
      $scope.activeBuilding.tabName = "SELECT BUILDING"
    $scope.activeBuilding.setName(name)
    $scope.activeBuilding.tabName = name


  $scope.buildingCode = (name)->    
    Buildings.buildingCode(name)


  $scope.toggleTopMenu  = (switchCompare)->
    was_comparison = false
    if $scope.comparisonState == true
      was_comparison = true
    $scope.comparisonState = false
    $scope.activeBuilding.tabName = "SELECT BUILDING"
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
      pane.style.top = '85px'

    if menu.style.height == "24px"
      $scope.bld_style = "margin-top: -200px"
    else
      $scope.bld_style = "margin-top: 50px"
      

  $scope.showCompareMenu = () ->    
    if $scope.comparisonState == false
      $scope.comparisonState = true
      $scope.activeBuilding.tabName = "COMPARISON MODE"
    # else 
    #   $scope.activeBuilding.tabName = $scope.activeBuilding.name
      bld = document.getElementById('building_wrap')
      menu = document.getElementById('ionTopMenu')
      pane = document.getElementsByTagName('ion-content')[0]
    else
      $scope.comparisonState = false
      $scope.activeBuilding.tabName = "SELECT BUILDING"

    if menu.offsetHeight == 24 
      menu.style.height = '250px' 
 #     pane.style.top = '350px'
    else 
      menu.style.height =  '24px' 
#      pane.style.top = '85px'

    if menu.style.height == "24px"
      $scope.bld_style = "margin-top: -200px"
    else
      $scope.bld_style = "margin-top: 50px"
   

  $scope.getFillColorFor = (bld_name) ->
    #console.log name, $scope.activeBuilding.getName() + " YESS"
    if $scope.activeBuilding == undefined
      return "none"
    else if $scope.activeBuilding.getName(bld_name)
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


).controller('VideoDetailCtrl', ($scope, $stateParams, Videos) ->
  $scope.video = Videos.get($stateParams.id)
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


).controller('WebcamsCtrl', ($scope, $log, Webcams) ->
  $scope.webcams = Webcams.all()
  $scope.activeWebcam = undefined
  $scope.nowLive = false
  $scope.nowLive4 = false

  
  # $scope.panoramas = undefined
  # $scope.timelapses = undefined

  $scope.isActive = (item) ->
    #console.log $scope.activeWebcam
    if $scope.activeWebcam == undefined
      false
    else if $scope.activeWebcam.id == item
      true
    else
      false

  $scope.getZoom = () ->
    $scope.currentZoom

  $scope.setZoom = (val) ->
    $scope.currentZoom = val


  $scope.setActiveWebcam = (activeWebcamId) ->   
    $scope.selected = activeWebcamId
    $scope.activeWebcam = Webcams.get(activeWebcamId)
    $scope.panoramas = Webcams.getPanoramas(activeWebcamId)
    $scope.timelapses = Webcams.getTimelapses(activeWebcamId)
    $scope.nowLive = false
    $scope.nowLive4 = false
    $scope.nowPano = false

    $log.debug($scope.panoramas)

  $scope.isEnabled = (model) ->
    model == undefined

  $scope.getActiveWebcam = (activeWebcam) ->
    $scope.activeWebcam    

  $scope.isLive = ->
    $scope.nowLive

  $scope.setLive = ->
    $scope.nowLive = !$scope.nowLive
    $scope.activeWebcam = undefined
    $scope.nowLive4 = false

  $scope.setLive4 = ->
    $scope.nowLive4 = !$scope.nowLive4
    $scope.activeWebcam = undefined
    $scope.nowLive = false

  
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


).controller('PresentationCtrl', ($scope,$log, $stateParams, Presentations) ->
  $scope.presentation = Presentations.get($stateParams.id)
  $scope.slides = Presentations.getSlides($stateParams.id)
  $scope.presentation_name = $scope.presentation.name
  $scope.project_name = $scope.presentation.project_name
  $scope.currentSlide = 1
  $scope.postSlide = (slideIdx) ->
    if slideIdx == $scope.slides.length 
      $scope.currentSlide = $scope.slides.length  
    if slideIdx == 1
      $scope.currentSlide = 1
    else
      $scope.currentSlide = slideIdx
  $scope.alertMe = ()->
    $log.debug("FUCK")    
  return


).controller('VideoPlayerCtrl', ($scope, $sce, $log, $stateParams, Videos) ->
  $scope.video = Videos.get($stateParams.id)
  #$log.debug($scope.video.recording);
  $scope.recording = $sce.trustAsResourceUrl($scope.video.recording)
  $scope.building_name = $scope.video.building_name 
  
  $scope.trustSrc = (src) ->
    $scope.videos = $sce.getTrustedResourceUrl(src);

  $scope.postVideoId = (videoId) ->
    $log.debug("FUCKYES "+ videoId)
  
  $scope.alertMe = ()->
    $log.debug("FUCK")    
  return


).controller('BuildingsCtrl', ($scope, Buildings, $log, ActiveBuilding) ->
  $scope.buildings = Buildings.all()
  $scope.templatePath = "templates/menu/building_menu.html"
  $scope.transformStyle = "scale(1.19)"
  $scope.activeBuilding = ActiveBuilding


  $scope.getTemplate = (name) ->
    Buildings.getTemplate(name)

  $scope.building_is = (code, name) ->
    if code == name
    # if name == "200 Mass"
      return true

  $scope.buildingCode = (name)->    
    Buildings.buildingCode(name)


  $scope.setActiveBuilding = (name)->
    if name == undefined
      $scope.activeBuilding.tabName = "SELECT BUILDING"
    ActiveBuilding.setName(name)
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
  $scope.panorama = Panoramas.get($stateParams.id)
  $scope.webcam_name = Panoramas.getWebcamName($stateParams.id)
  #console.log $scope.panorama.image
  $scope.currentZoom = 1.2


  $scope.zoomIn = (name) ->
    toZoom = document.getElementById(name)
    $scope.currentZoom = $scope.currentZoom + 0.2
    toZoom.style.transfrom = "scale("+$scope.currentZoom+")"
    toZoom.style.webkitTransform= "scale("+$scope.currentZoom+")"

  $scope.zoomOut = () ->    
    if $scope.currentZoom == 1.0 
      return
    toZoom = document.getElementById(name)
    $scope.currentZoom = $scope.currentZoom - 0.2
    toZoom.style.transfrom = "scale("+$scope.currentZoom+")"
    toZoom.style.webkitTransform= "scale("+$scope.currentZoom+")"


  $scope.getPanorama =  ->
    $scope.panorama.image

  $scope.getCamera =  ->
    1

).controller('VideoCtrl', ($scope, $stateParams, Videos, $location) ->
  $scope.video = Videos.get($stateParams.id)
  $scope.videoDiv = document.getElementById('video')
  $scope.seekBar = document.getElementById('seekbar')
  $scope.volume = document.getElementById('volume')
  $scope.skipValue = 0

  $scope.videoDiv.addEventListener 'timeupdate', ->
    # console.log 'test'
    # never calls
    value = (100 / $scope.videoDiv.duration) * $scope.videoDiv.currentTime;
    #console.log value
    $scope.seekBar.value = value
    return
  $scope.closeBtn =() ->
    $scope.videoDiv.pause()
    $location.path('#/dash/')

  $scope.seekRelease = ->
    currentTime = $scope.seekBar.value / (100 / $scope.videoDiv.duration);
    $scope.videoDiv.currentTime = currentTime;

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

  $scope.videoBw =  ->
    $scope.videoDiv.currentTime = $scope.videoDiv.currentTime - 5

  $scope.videoFw =  ->
    $scope.videoDiv.currentTime = $scope.videoDiv.currentTime + 5

  $scope.videoPlay =  ->
    if $scope.videoDiv.paused
      $scope.videoDiv.play()
    else
      $scope.videoDiv.pause()

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
  $scope.view = Views.get($stateParams.id)
  $scope.webcam_name = Views.getWebcamName($stateParams.id)

  $scope.getView =  ->
    $scope.view.image

  $scope.getCamera =  ->
    1


# generated by js2coffee 2.1.0