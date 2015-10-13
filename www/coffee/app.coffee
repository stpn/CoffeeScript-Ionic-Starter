angular.module('starter', [
  'ionic'
  'starter.controllers'
  'starter.services'
  'starter.filters'
  'starter.directives'
]).run(($ionicPlatform) ->
  $ionicPlatform.ready ->
    if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar true
      cordova.plugins.Keyboard.disableScroll true
      StatusBar.hide()
    return
  return
).config ($stateProvider, $urlRouterProvider, $ionicConfigProvider) ->
  $stateProvider.state('tab',
    url: '/tab'
    abstract: true
    templateUrl: 'templates/tabs.html').state('tab.dash',
    
    url: '/dash'
    views: 'tab-dash':
      templateUrl: 'templates/tab-dash.html'
      controller: 'DashCtrl').state('tab.presentations',
    
    url: '/presentations/:id'
    views: 'tab-dash':
      templateUrl: 'templates/Presentations/presentation.html'
      controller: 'PresentationCtrl').state('tab.videos',
    
    url: '/videos/:id'
    views: 'tab-dash':
      templateUrl: 'templates/Videos/videoPlayer.html'
      controller: 'VideoCtrl').state('tab.timelapses',
    
    url: '/timelapses/:id'
    views: 'webcams':
      templateUrl: 'templates/Videos/timelapsePlayer.html'
      controller: 'TimelapsesCtrl').state('tab.views',
    
    url: '/views/:id'
    views: 'tab-dash':
      templateUrl: 'templates/views/view.html'
      controller: 'ViewsCtrl').state('tab.home',
    
    url: '/home'
    views: 'home':
      templateUrl: 'templates/home.html'
      controller: 'HomeCtrl').state('tab.panoramas',
    
    url: '/panoramas/:cameraId'
    views: 'webcams':
      templateUrl: 'templates/panoramas/panorama.html'
      controller: 'PanoramasCtrl').state('tab.webcams',
    
    url: '/webcams'
    views: 'webcams':
      templateUrl: 'templates/webcams/webcams.html'
      controller: 'WebcamsCtrl').state('tab.buildings',
    
    url: '/buildings'
    views: 'buildings':
      templateUrl: 'templates/buildings/building_tab.html'
      controller: 'BuildingsCtrl').state 'tab.reset',

    url: '/reset'
    views: 'reset':
      templateUrl: 'templates/reset.html'
      controller: 'ResetCtrl'
      
  $urlRouterProvider.otherwise '/tab/home'
  return
# ---
# generated by coffee-script 1.9.2

# ---
# generated by js2coffee 2.1.0