angular.module('starter.controllers', []).controller('DashCtrl', ($scope, $rootScope,  $state,  $log, Renderings, Views, Floorplans, Videos, Webcams, Presentations, ActiveBuilding, TopmenuState, Buildings) -> 
  $scope.presentations = {}
#  $scope.factories = [{"Presentations": Presentations.all()}, {"Videos" : Videos.all()},  {"Floor Plans" : Floorplans.all()}, {"Rendering":Renderings.all()}, {"Views" : Views.all()},  {"Webcams" : Webcams.all()}]
  $scope.factories = [["Presentations", Presentations.all()], ["Videos", Videos.all()],  ["Floor Plans", Floorplans.all()], ["Rendering", Renderings.all()], ["Views", Views.all()],  ["Webcams", Webcams.all()]]
  $scope.activeBuilding = ActiveBuilding
  $scope.buldingTabName = "Select Buildings"
  $scope.state = $state;
  $scope.topMenu = TopmenuState.states


  $scope.buildings = Buildings.all()
  $scope.templatePath = "templates/menu/building_menu.html"
  $scope.compTemplate = "templates/menu/comparison_menu.html"
  $scope.bld_style="margin-top: 5px"
  $scope.transformStyle = "transform: scale(1.0)"
  $scope.topMenu = TopmenuState  

  $scope.isBuildings = () ->
    TopmenuState.getBuildings()

  $scope.isComparison = () ->    
    TopmenuState.getComparison()

  $scope.showCompareMenu = () ->
    proceed = false
    if TopmenuState.getComparison() == true
      proceed = true
      $scope.activeBuilding.tabName = $scope.activeBuilding.name
    else
      $scope.activeBuilding.tabName = "COMPARISON MODE"
    TopmenuState.setBuildings(false)
    TopmenuState.setComparison(true)
    menu = document.getElementById('ionTopMenu')
    if menu.offsetHeight == 4 || proceed == true
      $scope.toggleTopMenu()   

  $scope.isActive =(name) ->
    $scope.activeBuilding.isActive(name)

  $scope.toggleGroup = (group) ->
    $log.debug($scope.activeBuilding.name, "NAME")
    #$log.debug("GROUP: ",$scope.activeBuilding.getName())
    if $scope.isGroupShown(group)
      $scope.shownGroup = null
    else
      $scope.shownGroup = group
    return

  $scope.isGroupShown = (group) ->
    $scope.shownGroup == group    
  
  $scope.openPres = (presId) ->
    window.location = '#/tab/presentations/' + presId
    window.location.reload()
    return

  $scope.cancelActiveBuilding = ($event) ->
    
    bld_box = document.getElementById('building_menu_wrap')
    bld_box = bld_box.getBoundingClientRect()
    $log.debug($event.clientX,$event.clientY, bld_box)
    #if $event.target.nodeName != "SVG" # != document.getElementById('bld1') && $event.target != document.getElementById('bld2') && $event.target != document.getElementById('bld3') && $event.target != document.getElementById('bld4') && $event.target != document.getElementById('bld5') 
    if $event.clientX > bld_box.left && $event.clientX < bld_box.right && $event.clientY > bld_box.top && $event.clientY < bld_box.bottom
      return 
    else 
      $log.debug($event.clientX, $scope.activeBuilding.name)
      $scope.setActiveBuilding(undefined)

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
    ActiveBuilding.setName(name)
    $scope.activeBuilding.tabName = name


  $scope.buildingCode = (name)->    
    Buildings.buildingCode(name)


  $scope.toggleTopMenu = ->
    TopmenuState.setBuildings(true)
    TopmenuState.setComparison(false)

    bld = document.getElementById('building_wrap')
    menu = document.getElementById('ionTopMenu')
    pane = document.getElementsByTagName('ion-content')[0]
    # for pane in panes
     
    if menu.offsetHeight == 4 
      menu.style.height = '250px' 
      pane.style.top = '450px'
    else 
      menu.style.height =  '4px' 
      pane.style.top = '120px'

    if menu.style.height == "4px"
      $scope.bld_style = "margin-top: -200px"
    else
      $scope.bld_style = "margin-top: 50px"
    if TopmenuState.getBuildings() == false
      setTimeout (->
        TopmenuState.setBuildings(true)
        TopmenuState.setComparison(false)
      ), 1000      

    return 

  $scope.getFillColorFor = (bld) ->
    console.log name, $scope.activeBuilding.getName() + " YESS"
    if $scope.activeBuilding == undefined
      return "none"
    else if bld.name == $scope.activeBuilding.getName()
      console.log 'yess'
      return "#6D6F72"
    else 
      return "none"



).controller('VideoDetailCtrl', ($scope, $stateParams, Videos) ->
  $scope.video = Videos.get($stateParams.modelId)
  return

).controller('titleCtrl', ($scope, $stateParams) ->
  $scope.titleTemplate = "templates/menu/title.html"
  return


).controller('FloorplanDetailCtrl', ($scope, $stateParams, Floorplans) ->
  $scope.floorplan = Floorplans.get($stateParams.modelId)
  return


).controller('WebcamsCtrl', ($scope, $log, $stateParams, Webcams) ->
  $scope.webcams = Webcams.all()
  $scope.activeWebcam = undefined
  $scope.nowLive = false
  # $scope.panoramas = undefined
  # $scope.timelapses = undefined

  $scope.isActive = (item) ->
    console.log $scope.activeWebcam
    if $scope.activeWebcam == undefined
        false
    else if $scope.activeWebcam.id == item
      true
    else
      false


  $scope.setActiveWebcam = (activeWebcamId) ->   
    $scope.selected = activeWebcamId
    $scope.activeWebcam = Webcams.get(activeWebcamId)
    $scope.panoramas = Webcams.getPanoramas(activeWebcamId)
    $scope.timelapses = Webcams.getTimelapses(activeWebcamId)
    #$log.debug($scope.panoramas)

  $scope.isEnabled = (model) ->
    model == undefined

  $scope.getActiveWebcam = (activeWebcam) ->
    $scope.activeWebcam    

  $scope.isLive = ->
    $scope.nowLive

  $scope.setLive = ->
    $scope.nowLive = !$scope.nowLive

  $scope.toggleGroup = (group) ->
    if $scope.isGroupShown(group)
      $scope.shownGroup = null
    else
      $scope.shownGroup = group
    return

  $scope.isGroupShown = (group) ->
    $scope.shownGroup == group       
  return


).controller('PresentationCtrl', ($scope,$log, $stateParams, Presentations) ->
  $scope.presentation = Presentations.get($stateParams.presentationId)
  $scope.slides = Presentations.getSlides($stateParams.presentationId)
  $scope.presentation_name = $scope.presentation.name
  $scope.project_name = $scope.presentation.project_name
  $scope.postSlide = (slideId) ->
    $log.debug("FUCKYES "+ slideId)
  $scope.alertMe = ()->
    $log.debug("FUCK")    
  return


).controller('VideoPlayerCtrl', ($scope, $sce, $log, $stateParams, Videos) ->
  $scope.video = Videos.get($stateParams.videoId)
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



  $scope.getFillColorFor = (bld) ->
    console.log name, $scope.activeBuilding.getName() + " YESS"
    if $scope.activeBuilding == undefined
      return "none"
    else if bld.name == $scope.activeBuilding.getName()
      console.log 'yess'
      return "#6D6F72"
    else 
      return "none"

  return





).controller('PanoramasCtrl', ($scope, $stateParams, Panoramas, ActiveCamera, $ionicHistory) ->
  $scope.panorama = Panoramas.get($stateParams.panoramaId)
  $scope.webcam_name = Panoramas.getWebcamName($stateParams.panoramaId)

  $scope.getPanorama =  ->
    $scope.panorama.image

  $scope.getCamera =  ->
    1


).controller('TopMenuCtrl', ($scope, $sce, Buildings,ActiveBuilding, $log, $window, $location, TopmenuState) ->
  $scope.activeBuilding = ActiveBuilding
  $scope.buildings = Buildings.all()
  $scope.templatePath = "templates/menu/building_menu.html"
  $scope.compTemplate = "templates/menu/comparison_menu.html"
  $scope.bld_style="margin-top: 5px"
  $scope.transformStyle = "transform: scale(1.0)"
  $scope.topMenu = TopmenuState

  $scope.cancelActiveBuilding = () ->
    ActiveBuilding.name = undefined
    
  $scope.building_is = (code, name) ->
    if code == name
    # if name == "200 Mass"
      return true

  $scope.getTemplate = (name) ->
    Buildings.getTemplate(name)

  $scope.setActiveBuilding = (name)->
    $log.debug(name)
    #ActiveBuilding.name = name

  $scope.buildingCode = (name)->    
    if name == "M201"    
      return "201"
    if name == "M600"
      return "600"
    else
      return name


  $scope.toggleTopMenu = ->
    bld = document.getElementById('building_wrap')
    menu = document.getElementById('ionTopMenu')
    pane = document.getElementsByTagName('ion-content')[0]
    # for pane in panes
     
    if menu.offsetHeight == 4 
      menu.style.height = '350px' 
      pane.style.top = '450px'
    else 
      menu.style.height =  '4px' 
      pane.style.top = '120px'

    if menu.style.height == "4px"
      $scope.bld_style = "margin-top: -200px"
    else
      $scope.bld_style = "margin-top: 50px"
    if TopmenuState.getBuildings() == false
      setTimeout (->
        TopmenuState.setBuildings(true)
        TopmenuState.setComparison(false)
      ), 1000      

    return 
).controller('VideoCtrl', ($scope, $stateParams, Videos) ->
  $scope.video = Videos.get($stateParams.videoId)
  $scope.videoDiv = document.getElementById('video')
  $scope.seekBar = document.getElementById('seekbar')
  $scope.volume = document.getElementById('volume')
  $scope.skipValue = 0

  $scope.videoDiv.addEventListener 'timeupdate', ->
    # console.log 'test'
    # never calls
    value = (100 / $scope.videoDiv.duration) * $scope.videoDiv.currentTime;
    console.log value
    $scope.seekBar.value = value
    return

  $scope.seekRelease = ->
    currentTime = $scope.seekBar.value / (100 / $scope.videoDiv.duration);
    $scope.videoDiv.currentTime = currentTime;

  $scope.volumeUp = ->
    console.log 'UP'
    if $scope.volume.value < 100
      $scope.volume.value = $scope.volume.value + 5
    else
      $scope.volume.value = 100

  $scope.volumeDown = ->
    console.log 'DOWN'
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

).controller 'HomeCtrl', ($scope) ->
  $scope.settings = enableFriends: true
  return   
# ---
# generated by js2coffee 2.1.0