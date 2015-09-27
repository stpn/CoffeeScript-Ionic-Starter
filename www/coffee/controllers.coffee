angular.module('starter.controllers', []).controller('DashCtrl', ($scope, $rootScope,  $state,  $log, Renderings, Views, Floorplans, Videos, Webcams, Presentations, ActiveBuilding, TopmenuState, Buildings) -> 
  $scope.presentations = {}
#  $scope.factories = [{"Presentations": Presentations.all()}, {"Videos" : Videos.all()},  {"Floor Plans" : Floorplans.all()}, {"Rendering":Renderings.all()}, {"Views" : Views.all()},  {"Webcams" : Webcams.all()}]
  $scope.factories = [["Presentations", Presentations.all()], ["Videos", Videos.all()],  ["Floor Plans", Floorplans.all()], ["Rendering", Renderings.all()], ["Views", Views.all()],  ["Webcams", Webcams.all()]]
  $scope.activeBuilding = ActiveBuilding
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
    
  $scope.building_is = (code, name) ->
    if code == name
    # if name == "200 Mass"
      return true

  $scope.getTemplate = (name) ->
    Buildings.getTemplate(name)

  $scope.setActiveBuilding = (name)->
    $log.debug(name)
    ActiveBuilding.setName(name)


  $scope.buildingCode = (name)->    
    Buildings.buildingCode(name)


  $scope.toggleTopMenu = ->
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
  # $scope.panoramas = undefined
  # $scope.timelapses = undefined

  $scope.isActive = (item) ->
    $scope.selected == item


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

  $scope.showPanorama = ->
    $log.debug("PANO")

  $scope.showLive = ->
    $log.debug("LIVE")

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
  
  $scope.trustSrc = (src) ->
    $scope.videos = $sce.getTrustedResourceUrl(src);

  $scope.postVideoId = (videoId) ->
    $log.debug("FUCKYES "+ videoId)
  
  $scope.alertMe = ()->
    $log.debug("FUCK")    
  return


).controller('BuildingsCtrl', ($scope, Buildings, $log) ->
  $scope.buildings = Buildings.all()
  $scope.templatePath = "templates/menu/building_menu.html"
  $scope.transformStyle = "scale(1.19)"

  $scope.getTemplate = (name) ->
    Buildings.getTemplate(name)

  $scope.building_is = (code, name) ->
    if code == name
    # if name == "200 Mass"
      return true

  $scope.buildingCode = (name)->    
    Buildings.buildingCode(name)

  return


).controller('PanoramasCtrl', ($scope, $stateParams, Panoramas, ActiveCamera) ->
  $scope.panorama = Panoramas.get($stateParams.panoramaId)

  $scope.getPanorama =  ->
    $scope.panorama.image

  $scope.getCamera =  ->
    1


  return

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


).controller('ChatsCtrl', ($scope, Chats) ->
  # With the new view caching in Ionic, Controllers are only called
  # when they are recreated or on app start, instead of every page change.
  # To listen for when this page is active (for example, to refresh data),
  # listen for the $ionicView.enter event:
  #
  #$scope.$on('$ionicView.enter', function(e) {
  #});
  $scope.chats = Chats.all()

  $scope.remove = (chat) ->
    Chats.remove chat
    return

  return

).controller('ChatDetailCtrl', ($scope, $stateParams, Chats) ->
  $scope.chat = Chats.get($stateParams.chatId)
  return

).controller 'AccountCtrl', ($scope) ->
  $scope.settings = enableFriends: true
  return  
# ---
# generated by js2coffee 2.1.0