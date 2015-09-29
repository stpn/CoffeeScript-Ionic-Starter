# Ionic Starter App
# angular.module is a global place for creating, registering and retrieving Angular modules
# 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
# the 2nd parameter is an array of 'requires'
# 'starter.services' is found in services.js
# 'starter.controllers' is found in controllers.js
angular.module('starter', [
  'ionic'
  'starter.controllers'
  'starter.services'
  'starter.filters'
  'starter.directives'  
]).run(($ionicPlatform) ->
  $ionicPlatform.ready ->
    # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    # for form inputs)
    if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar true
      cordova.plugins.Keyboard.disableScroll true
    if window.StatusBar
      # org.apache.cordova.statusbar required
      StatusBar.styleLightContent()
    return
  return
).config ($stateProvider, $urlRouterProvider) ->
  # Ionic uses AngularUI Router which uses the concept of states
  # Learn more here: https://github.com/angular-ui/ui-router
  # Set up the various states which the app can be in.
  # Each state's controller can be found in controllers.js
  $stateProvider.state('tab',
    url: '/tab'
    abstract: true
    templateUrl: 'templates/tabs.html'
    # views:
    #   'bld-menu': templateUrl: 'templates/menu/building_menu.html'

    ).state('tab.dash',
    url: '/dash'
    views: 'tab-dash':
      templateUrl: 'templates/tab-dash.html'
      controller: 'DashCtrl'


      ).state('tab.presentations',
    url: '/presentations/:presentationId'
    views: 'tab-dash':
      templateUrl: 'templates/Presentations/presentation.html'
      controller: 'PresentationCtrl'
      

      ).state('tab.videos',
    url: '/videos/:videoId'
    views: 'tab-dash':
      templateUrl: 'templates/Videos/videoPlayer.html'
      controller: 'VideoPlayerCtrl'     


    ).state('tab.home',
    url: '/home'
    views: 'home':
      templateUrl: 'templates/home.html'
      controller: 'HomeCtrl',   

    ).state('tab.panoramas',
    url: '/panoramas/:panoramaId'
    views: 'webcams':
      templateUrl: 'templates/panoramas/panorama.html'
      controller: 'PanoramasCtrl',          

    ).state('tab.webcams',
    url: '/webcams'
    views: 'webcams':
      templateUrl: 'templates/webcams/webcams.html'
      controller: 'WebcamsCtrl',

    ).state('tab.buildings',
    url: '/buildings'
    views: 'buildings':
      templateUrl: 'templates/buildings/building_tab.html'
      controller: 'BuildingsCtrl',       

      ).state('tab.chats',      
    url: '/chats'
    views: 'tab-chats':
      templateUrl: 'templates/tab-chats.html'
      controller: 'ChatsCtrl'
      

      ).state('tab.chat-detail',
    url: '/chats/:chatId'
    views: 'tab-chats':
      templateUrl: 'templates/chat-detail.html'
      controller: 'ChatDetailCtrl'


      ).state 'tab.account',
    url: '/account'
    views: 'tab-account':
      templateUrl: 'templates/tab-account.html'
      controller: 'AccountCtrl'
  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise '/tab/dash'
  return

# ---
# generated by js2coffee 2.1.0