angular.module('starter', ['ionic', 'starter.controllers', 'starter.services', 'starter.filters', 'starter.directives']).run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);
      StatusBar.hide();
    }
  });
}).config(function($stateProvider, $urlRouterProvider, $ionicConfigProvider) {
  $stateProvider.state('tab', {
    url: '/tab',
    abstract: true,
    templateUrl: 'templates/tabs.html'
  }).state('tab.dash', {
    url: '/dash',
    views: {
      'tab-dash': {
        templateUrl: 'templates/tab-dash.html',
        controller: 'DashCtrl'
      }
    }
  }).state('tab.presentations', {
    url: '/presentations/:id',
    views: {
      'tab-dash': {
        templateUrl: 'templates/Presentations/presentation.html',
        controller: 'PresentationCtrl'
      }
    }
  }).state('tab.videos', {
    url: '/videos/:id',
    views: {
      'tab-dash': {
        templateUrl: 'templates/Videos/videoPlayer.html',
        controller: 'VideoPlayerCtrl'
      }
    }
  }).state('tab.timelapses', {
    url: '/timelapses/:id',
    views: {
      'webcams': {
        templateUrl: 'templates/Videos/timelapsePlayer.html',
        controller: 'TimelapsesCtrl'
      }
    }
  }).state('tab.views', {
    url: '/views/:id',
    views: {
      'tab-dash': {
        templateUrl: 'templates/views/view.html',
        controller: 'ViewsCtrl'
      }
    }
  }).state('tab.home', {
    url: '/home',
    views: {
      'home': {
        templateUrl: 'templates/home.html',
        controller: 'HomeCtrl'
      }
    }
  }).state('tab.panoramas', {
    url: '/panoramas/:id',
    views: {
      'webcams': {
        templateUrl: 'templates/panoramas/panorama.html',
        controller: 'PanoramasCtrl'
      }
    }
  }).state('tab.webcams', {
    url: '/webcams',
    views: {
      'webcams': {
        templateUrl: 'templates/webcams/webcams.html',
        controller: 'WebcamsCtrl'
      }
    }
  }).state('tab.buildings', {
    url: '/buildings',
    views: {
      'buildings': {
        templateUrl: 'templates/buildings/building_tab.html',
        controller: 'BuildingsCtrl'
      }
    }
  }).state('tab.reset', {
    url: '/reset',
    views: {
      'reset': {
        templateUrl: 'templates/reset.html',
        controller: 'ResetCtrl'
      }
    }
  });
  $urlRouterProvider.otherwise('/tab/home');
});

angular.module('starter.controllers', []).controller('DashCtrl', function($scope, $rootScope, $state, $log, Renderings, Views, Floorplans, Videos, Webcams, Presentations, ActiveBuilding, TopmenuState, Buildings) {
  $scope.presentations = {};
  $scope.factories = [["Presentations", Presentations.sorted()], ["Videos", Videos.sorted()], ["Floor Plans", Floorplans.sorted()], ["Rendering", Renderings.sorted()], ["Views", Views.sorted()], ["Webcams", Webcams.sorted()]];
  $scope.activeBuilding = ActiveBuilding;
  $scope.activeBuildingName = void 0;
  $scope.lastActiveName = void 0;
  $scope.buldingTabName = "Select Buildings";
  $scope.activeComparison = void 0;
  $scope.comparisonState = false;
  $scope.buildings = Buildings.all();
  $scope.templatePath = "templates/menu/building_menu.html";
  $scope.compTemplate = "templates/menu/comparison_menu.html";
  $scope.bld_style = "margin-top: -200px";
  $scope.transformStyle = "transform: scale(1.0)";
  $scope.clicker_default = "61px";
  $scope.clicker_narrow = "40px";
  $scope.clicker_extranarrow = "16px";
  $scope.clicker_padding = $scope.clicker_default;
  $scope.accordionHeight = "0px";
  $scope.showOverlay = false;
  $scope.isComparison = function() {
    return $scope.comparisonState;
  };
  $scope.isActiveBuilding = function(name) {
    if ($scope.activeBuildingName === void 0) {
      return true;
    }
    return $scope.activeBuildingName === name;
  };
  $scope.toggleGroup = function(group) {
    var menu;
    menu = document.getElementById('ionTopMenu');
    if (menu.style.height === '250px') {
      $scope.toggleTopMenu();
    }
    if ($scope.isGroupShown(group)) {
      $scope.shownGroup = null;
      $scope.toggled = null;
      $scope.clicker_padding = $scope.clicker_default;
    } else {
      $scope.shownGroup = group;
      $scope.toggled = true;
      $scope.clicker_padding = $scope.clicker_extranarrow;
    }
  };
  $scope.isGroupShown = function(group) {
    return $scope.shownGroup === group;
  };
  $scope.groupHeight = function(group) {
    if ($scope.isGroupShown(group) === true) {
      return "153px";
    } else {
      return "0px";
    }
  };
  $scope.isGroupClicked = function(group) {
    if ($scope.isGroupShown(group)) {
      return "603px";
    } else {
      return "";
    }
  };
  $scope.openPres = function(presId) {
    window.location = '#/tab/presentations/' + presId;
    window.location.reload();
  };
  $scope.cancelActiveBuilding = function($event) {
    var bld_box;
    bld_box = document.getElementById('building_menu_wrap');
    bld_box = bld_box.getBoundingClientRect();
    if ($event.clientX > bld_box.left && $event.clientX < bld_box.right && $event.clientY > bld_box.top && $event.clientY < bld_box.bottom) {

    } else {
      $scope.setActiveBuilding(void 0);
      return $scope.activeBuilding.cancelAll();
    }
  };
  $scope.building_is = function(code, name) {
    if (code === name) {
      return true;
    }
  };
  $scope.getTemplate = function(name) {
    return Buildings.getTemplate(name);
  };
  $scope.setActiveBuilding = function(name) {
    if ($scope.activeBuildingName === name) {
      name = void 0;
    }
    $scope.activeBuildingName = name;
    return $scope.buldingTabName = name;
  };
  $scope.buildingCode = function(name) {
    return Buildings.buildingCode(name);
  };
  $scope.toggleTopMenu = function(switchCompare) {
    var bld, menu, pane, was_comparison;
    was_comparison = false;
    if ($scope.comparisonState === true) {
      was_comparison = true;
    }
    $scope.comparisonState = false;
    $scope.buldingTabName = $scope.activeBuildingName;
    $scope.activeBuilding.tabName = $scope.lastActiveName;
    bld = document.getElementById('building_wrap');
    menu = document.getElementById('ionTopMenu');
    pane = document.getElementsByTagName('ion-content')[0];
    if (menu.offsetHeight === 24) {
      $scope.toggleGroup($scope.shownGroup);
      menu.style.height = '250px';
      $scope.clicker_padding = $scope.clicker_narrow;
      pane.style.top = '320px';
    } else {
      menu.style.height = '24px';
      if (was_comparison === false) {
        $scope.clicker_padding = $scope.clicker_default;
      }
      pane.style.top = '70px';
    }
    if (menu.style.height === "24px") {
      return $scope.bld_style = "margin-top: -200px";
    } else {
      return $scope.bld_style = "margin-top: 50px";
    }
  };
  $scope.showCompareMenu = function() {
    var bld, menu, pane;
    if ($scope.comparisonState === false) {
      $scope.comparisonState = true;
      $scope.buldingTabName = "COMPARISON MODE";
      bld = document.getElementById('building_wrap');
      menu = document.getElementById('ionTopMenu');
      pane = document.getElementsByTagName('ion-content')[0];
    } else {
      $scope.comparisonState = false;
      $scope.buldingTabName = $scope.activeBuildingName;
    }
    if (menu.offsetHeight === 24) {
      menu.style.height = '250px';
    } else {
      menu.style.height = '24px';
    }
    if (menu.style.height === "24px") {
      return $scope.bld_style = "margin-top: -200px";
    } else {
      return $scope.bld_style = "margin-top: 50px";
    }
  };
  $scope.getFillColorFor = function(bld_name) {
    if ($scope.activeBuildingName === void 0) {
      return "none";
    } else if ($scope.activeBuildingName === bld_name || $scope.activeBuildingName === "all") {
      return "#6D6F72";
    } else {
      return "none";
    }
  };
  $scope.convertCode = function(name) {
    if (name === "200M") {
      return "M200";
    }
    if (name === "250M") {
      return "M250";
    }
    if (name === "600") {
      return "M600";
    }
    if (name === "201F") {
      return "F201";
    }
    if (name === "200F") {
      return "F200";
    }
  };
  $scope.setActiveComparison = function(comparison) {
    if (comparison === $scope.activeComparison) {
      comparison = void 0;
    }
    return $scope.activeComparison = comparison;
  };
  return $scope.getComparisonStroke = function(comparison) {
    if (comparison === $scope.activeComparison) {
      return "#FFF";
    } else {
      return "#808080";
    }
  };
}).controller('titleCtrl', function($scope, $stateParams) {
  $scope.titleTemplate = "templates/menu/title.html";
  $scope.home = '#/tab/home';
  $scope.dash = "#/tab/dash";
  $scope.buildings = "#/tab/buildings";
}).controller('FloorplanDetailCtrl', function($scope, $stateParams, Floorplans) {
  $scope.floorplan = Floorplans.get($stateParams.id);
}).controller('WebcamsCtrl', function($scope, $log, Webcams) {
  $scope.webcams = Webcams.all();
  $scope.activeWebcam = void 0;
  $scope.nowLive = false;
  $scope.nowLive4 = false;
  $scope.isActive = function(item) {
    if ($scope.activeWebcam === void 0) {
      return false;
    } else if ($scope.activeWebcam.id === item) {
      return true;
    } else {
      return false;
    }
  };
  $scope.getZoom = function() {
    return $scope.currentZoom;
  };
  $scope.setZoom = function(val) {
    return $scope.currentZoom = val;
  };
  $scope.setActiveWebcam = function(activeWebcamId) {
    $scope.selected = activeWebcamId;
    $scope.activeWebcam = Webcams.get(activeWebcamId);
    $scope.panoramas = Webcams.getPanoramas(activeWebcamId);
    $scope.timelapses = Webcams.getTimelapses(activeWebcamId);
    $scope.nowLive = false;
    $scope.nowLive4 = false;
    $scope.nowPano = false;
    return $log.debug($scope.panoramas);
  };
  $scope.isEnabled = function(model) {
    return model === void 0;
  };
  $scope.getActiveWebcam = function(activeWebcam) {
    return $scope.activeWebcam;
  };
  $scope.isLive = function() {
    return $scope.nowLive;
  };
  $scope.setLive = function() {
    $scope.nowLive = !$scope.nowLive;
    $scope.activeWebcam = void 0;
    return $scope.nowLive4 = false;
  };
  $scope.setLive4 = function() {
    $scope.nowLive4 = !$scope.nowLive4;
    $scope.activeWebcam = void 0;
    return $scope.nowLive = false;
  };
  $scope.isLive4 = function() {
    return $scope.nowLive4;
  };
  $scope.isPano = function() {
    return $scope.nowPano;
  };
  $scope.setPano = function() {
    return $scope.nowPano = true;
  };
  $scope.toggleGroup = function(group) {
    if ($scope.isGroupShown(group)) {
      $scope.shownGroup = null;
      $scope.accordionHeight = "0px";
    } else {
      $scope.shownGroup = group;
      $scope.accordionHeight = "593px";
    }
  };
  $scope.isGroupShown = function(group) {
    return $scope.shownGroup === group;
  };
}).controller('PresentationCtrl', function($scope, $log, $stateParams, Presentations) {
  $scope.presentation = Presentations.get($stateParams.id);
  $scope.slides = Presentations.getSlides($stateParams.id);
  $scope.presentation_name = $scope.presentation.name;
  $scope.project_name = $scope.presentation.project_name;
  $scope.currentSlide = 1;
  $scope.postSlide = function(slideIdx) {
    if (slideIdx >= $scope.slides.length) {
      return $scope.currentSlide = $scope.slides.length;
    } else if (slideIdx <= 1) {
      return $scope.currentSlide = 1;
    } else {
      return $scope.currentSlide = slideIdx;
    }
  };
  $scope.alertMe = function() {
    return $log.debug("...");
  };
}).controller('VideoPlayerCtrl', function($scope, $sce, $log, $stateParams, Videos) {
  $scope.video = Videos.get($stateParams.id);
  $scope.recording = $sce.trustAsResourceUrl($scope.video.recording);
  $scope.building_name = $scope.video.building_name;
  $scope.trustSrc = function(src) {
    return $scope.videos = $sce.getTrustedResourceUrl(src);
  };
  $scope.postVideoId = function(videoId) {
    return $log.debug("....  " + videoId);
  };
  $scope.alertMe = function() {
    return $log.debug("...");
  };
}).controller('BuildingsCtrl', function($scope, Buildings, $log, ActiveCrestron) {
  $scope.buildings = Buildings.all();
  $scope.templatePath = "templates/menu/building_menu.html";
  $scope.transformStyle = "scale(1.19)";
  $scope.activeBuilding = ActiveCrestron;
  $scope.getTemplate = function(name) {
    return Buildings.getTemplate(name);
  };
  $scope.building_is = function(code, name) {
    if (code === name) {
      return true;
    }
  };
  $scope.buildingCode = function(name) {
    return Buildings.buildingCode(name);
  };
  $scope.setActiveBuilding = function(name) {
    if (name === "all") {
      if ($scope.activeBuilding.isActive("all")) {
        $scope.activeBuilding.cancelAll();
        $scope.activeBuilding.setName("all");
      } else {
        $scope.activeBuilding.setAll();
      }
    } else {
      if ($scope.activeBuilding.isActive("all")) {
        $scope.activeBuilding.setName("all");
      }
    }
    $scope.activeBuilding.setName(name);
    return $scope.activeBuilding.tabName = name;
  };
  $scope.getFillColorFor = function(bld_name) {
    if ($scope.activeBuilding === void 0) {
      return "none";
    } else if ($scope.activeBuilding.getName(bld_name)) {
      return "#6D6F72";
    } else {
      return "none";
    }
  };
  $scope.convertCode = function(name) {
    if (name === "200M") {
      return "M200";
    }
    if (name === "250M") {
      return "M250";
    }
    if (name === "600") {
      return "M600";
    }
    if (name === "201F") {
      return "F201";
    }
    if (name === "200F") {
      return "F200";
    }
  };
}).controller('PanoramasCtrl', function($scope, $stateParams, Panoramas, ActiveCamera, $ionicHistory) {
  $scope.panorama = Panoramas.get($stateParams.id);
  $scope.webcam_name = Panoramas.getWebcamName($stateParams.id);
  $scope.currentZoom = 1.0;
  $scope.zoomIn = function(name) {
    var toZoom;
    console.log($scope.currentZoom);
    if ($scope.currentZoom <= 0.4) {
      return;
    }
    toZoom = document.getElementById(name);
    $scope.currentZoom = $scope.currentZoom - 0.2;
    toZoom.style.transfrom = "scale(" + $scope.currentZoom + ")";
    return toZoom.style.webkitTransform = "scale(" + $scope.currentZoom + ")";
  };
  $scope.zoomOut = function(name) {
    var toZoom;
    console.log($scope.currentZoom);
    if ($scope.currentZoom >= 1.0) {
      return;
    }
    toZoom = document.getElementById(name);
    $scope.currentZoom = $scope.currentZoom + 0.2;
    toZoom.style.transfrom = "scale(" + $scope.currentZoom + ")";
    return toZoom.style.webkitTransform = "scale(" + $scope.currentZoom + ")";
  };
  $scope.getPanorama = function() {
    return $scope.panorama.image;
  };
  return $scope.getCamera = function() {
    return 1;
  };
}).controller('VideoCtrl', function($scope, $stateParams, Videos, $location) {
  $scope.video = Videos.get($stateParams.id);
  $scope.videoDiv = document.getElementById('video');
  $scope.seekBar = document.getElementById('seekbar');
  $scope.volume = document.getElementById('volume');
  $scope.skipValue = 0;
  $scope.mute = false;
  $scope.max = 80;
  $scope.videoState = true;
  $scope.videoDiv.addEventListener('timeupdate', function() {
    var value;
    value = (100 / $scope.videoDiv.duration) * $scope.videoDiv.currentTime;
    $scope.seekBar.value = value;
  });
  $scope.closeBtn = function() {
    $scope.videoDiv.pause();
    return $location.path('#/dash/');
  };
  $scope.update = function() {
    return $scope.videoDiv.pause();
  };
  $scope.seekRelease = function() {
    var currentTime;
    currentTime = $scope.seekBar.value / (100 / $scope.videoDiv.duration);
    $scope.videoDiv.currentTime = currentTime;
    if ($scope.videoState) {
      return $scope.videoDiv.play();
    }
  };
  $scope.volumeUp = function() {
    if ($scope.volume.value < 100) {
      return $scope.volume.value = $scope.volume.value + 5;
    } else {
      return $scope.volume.value = 100;
    }
  };
  $scope.volumeDown = function() {
    if ($scope.volume.value > 0) {
      return $scope.volume.value = $scope.volume.value - 5;
    } else {
      return $scope.volume.value = 0;
    }
  };
  $scope.videoBack = function() {
    return $scope.videoDiv.currentTime = 0;
  };
  $scope.videoBw = function() {
    return $scope.videoDiv.currentTime = $scope.videoDiv.currentTime - 5;
  };
  $scope.videoFw = function() {
    return $scope.videoDiv.currentTime = $scope.videoDiv.currentTime + 5;
  };
  $scope.videoPlay = function() {
    if ($scope.videoDiv.paused) {
      $scope.videoDiv.play();
      return $scope.videoState = true;
    } else {
      $scope.videoDiv.pause();
      return $scope.videoState = false;
    }
  };
  $scope.isMute = function() {
    return $scope.mute;
  };
  $scope.setMute = function() {
    return $scope.mute = !$scope.mute;
  };
  $scope.progressRelease = function($event) {
    if ($event.gesture.deltaX > 0) {
      if ($scope.volume.value >= 100) {
        return $scope.volume.value = 100;
      } else {
        return $scope.volume.value = $scope.volume.value + 5 / $scope.volume.getBoundingClientRect().width * $scope.max;
      }
    } else {
      if ($scope.volume.value <= 0) {
        return $scope.volume.value = 0;
      } else {
        return $scope.volume.value = $scope.volume.value - 5 / $scope.volume.getBoundingClientRect().width * $scope.max;
      }
    }
  };
}).controller('TimelapsesCtrl', function($scope, $sce, $log, $stateParams, Timelapses, $location) {
  $scope.video = Timelapses.get($stateParams.id);
  $scope.videoDiv = document.getElementById('video');
  $scope.seekBar = document.getElementById('seekbar');
  $scope.volume = document.getElementById('volume');
  $scope.skipValue = 0;
  $scope.mute = false;
  $scope.max = 80;
  $scope.recording = $sce.trustAsResourceUrl($scope.video.recording);
  $scope.building_name = $scope.video.building_name;
  $scope.videoState = true;
  $scope.trustSrc = function(src) {
    return $scope.videos = $sce.getTrustedResourceUrl(src);
  };
  $scope.update = function() {
    $scope.videoDiv.pause();
    return $scope.videoState = true;
  };
  $scope.videoDiv.addEventListener('timeupdate', function() {
    var value;
    value = (100 / $scope.videoDiv.duration) * $scope.videoDiv.currentTime;
    $scope.seekBar.value = value;
  });
  $scope.closeBtn = function() {
    $scope.videoDiv.pause();
    return $location.path('#/dash/');
  };
  $scope.seekRelease = function() {
    var currentTime;
    currentTime = $scope.seekBar.value / (100 / $scope.videoDiv.duration);
    $scope.videoDiv.currentTime = currentTime;
    if ($scope.videoState) {
      return $scope.videoDiv.play();
    }
  };
  $scope.volumeUp = function() {
    if ($scope.volume.value < 100) {
      return $scope.volume.value = $scope.volume.value + 5;
    } else {
      return $scope.volume.value = 100;
    }
  };
  $scope.volumeDown = function() {
    if ($scope.volume.value > 0) {
      return $scope.volume.value = $scope.volume.value - 5;
    } else {
      return $scope.volume.value = 0;
    }
  };
  $scope.videoBack = function() {
    return $scope.videoDiv.currentTime = 0;
  };
  $scope.videoBw = function() {
    return $scope.videoDiv.currentTime = $scope.videoDiv.currentTime - 5;
  };
  $scope.videoFw = function() {
    return $scope.videoDiv.currentTime = $scope.videoDiv.currentTime + 5;
  };
  $scope.videoPlay = function() {
    if ($scope.videoDiv.paused) {
      $scope.videoDiv.play();
      return $scope.videoState = true;
    } else {
      $scope.videoDiv.pause();
      return $scope.videoState = false;
    }
  };
  $scope.isMute = function() {
    return $scope.mute;
  };
  $scope.setMute = function() {
    return $scope.mute = !$scope.mute;
  };
  $scope.progressRelease = function($event) {
    if ($event.gesture.deltaX > 0) {
      if ($scope.volume.value >= 100) {
        return $scope.volume.value = 100;
      } else {
        return $scope.volume.value = $scope.volume.value + 5 / $scope.volume.getBoundingClientRect().width * $scope.max;
      }
    } else {
      if ($scope.volume.value <= 0) {
        return $scope.volume.value = 0;
      } else {
        return $scope.volume.value = $scope.volume.value - 5 / $scope.volume.getBoundingClientRect().width * $scope.max;
      }
    }
  };
}).controller('HomeCtrl', function($scope) {
  $scope.home = "HOME";
}).controller('ResetCtrl', function($scope, $ionicHistory) {
  $scope.goBack = function() {
    return window.history.back();
  };
  $scope.go = function(path) {
    return $location.path(path);
  };
}).controller('ViewsCtrl', function($scope, $stateParams, Views, ActiveCamera, $ionicHistory) {
  $scope.view = Views.get($stateParams.id);
  $scope.webcam_name = Views.getWebcamName($stateParams.id);
  $scope.getView = function() {
    return $scope.view.image;
  };
  return $scope.getCamera = function() {
    return 1;
  };
});

Number.prototype.map = function(in_min, in_max, out_min, out_max) {
  return (this - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
};

angular.module('starter.filters', []).filter('buildingFilter', [
  function() {
    return function(models, activeBuilding) {
      var tempClients;
      if (!angular.isUndefined(models) && !angular.isUndefined(activeBuilding) && activeBuilding.length > 0) {
        tempClients = [];
        angular.forEach(models, function(model) {
          if (angular.equals(model.building_name, activeBuilding)) {
            console.log(activeBuilding, model.building_name);
            return tempClients.push(model);
          }
        });
        return tempClients;
      } else {
        return models;
      }
    };
  }
]);

angular.module('starter.directives', []).directive('clickSvg', [
  'ActiveBuilding', function(activeBuilding) {
    return {
      scope: {
        clickSvg: '='
      },
      link: function(scope, element, attrs) {
        return element.bind('click', function() {
          var name;
          name = scope.clickSvg;
        });
      }
    };
  }
]);

angular.module('starter.directives', []).directive('backImg', function() {
  return function(scope, element, attrs) {
    attrs.$observe('backImg', function(value) {
      element.css({
        'background-image': 'url(' + value + ')',
        'background-size': 'cover'
      });
    });
  };
});

angular.module('starter.directives', []).directive('ionPpinch', function($timeout) {
  return {
    restrict: 'E',
    link: function($scope, $element, attrs) {
      if ($element[0].classList[0] !== "square") {
        return;
      }
      return $timeout(function() {
        var bottomYLimit, bufferX, bufferY, dragReady, lastMaxX, lastMaxY, lastMinX, lastMinY, lastPosX, lastPosY, lastScale, last_rotation, leftXLimit, max, oldScale, posX, posY, rightXLimit, rotation, scale, square, topYLimit;
        square = $element[0];
        posX = 0;
        posY = 0;
        lastPosX = 0;
        lastPosY = 0;
        bufferX = 0;
        bufferY = 0;
        scale = 1;
        lastScale = void 0;
        rotation = 0;
        last_rotation = void 0;
        dragReady = 0;
        leftXLimit = 44;
        rightXLimit = 720;
        topYLimit = 197;
        bottomYLimit = 385;
        lastMaxX = 0;
        lastMinX = void 0;
        lastMaxY = 0;
        lastMinY = 0;
        max = 200;
        oldScale = 0;
        return ionic.onGesture('touch drag dragend transform', (function(e) {
          var LastMinX, match, scalRgxp, transform;
          e.gesture.srcEvent.preventDefault();
          e.gesture.preventDefault();
          scalRgxp = /scale\((\d{1,}\.\d{1,})\)/;
          match = e.target.style.transform.match(scalRgxp);
          if (!match) {
            match = [""];
          } else {
            if (oldScale !== match[1]) {
              LastMinX = void 0;
              oldScale = match[1];
            }
          }
          switch (e.type) {
            case 'touch':
              lastScale = scale;
              break;
            case 'drag':
              if (square.getBoundingClientRect().left > leftXLimit && square.getBoundingClientRect().top > topYLimit && square.getBoundingClientRect().bottom < bottomYLimit && square.getBoundingClientRect().right < rightXLimit) {
                posX = e.gesture.deltaX / square.getBoundingClientRect().width * max + lastPosX;
                posY = e.gesture.deltaY / square.getBoundingClientRect().height * max + lastPosY;
                if (lastMinX !== void 0) {
                  if (posX < lastMinX) {
                    posX = lastMinX;
                  }
                }
                if (posX > lastMaxX && lastMaxX > 0) {
                  posX = lastMaxX;
                }
                if (posY < lastMinY) {
                  posY = lastMinY;
                }
                if (posY > lastMaxY && lastMaxY > 0) {
                  posY = lastMaxY;
                }
                console.log(square.getBoundingClientRect().top, " < TOP", square.getBoundingClientRect().left, " <LEFT", posX, " < posX", lastMinX, " <LastMinX");
              } else {
                if (square.getBoundingClientRect().left <= leftXLimit) {
                  lastPosX = lastPosX + 1;
                  lastMinX = lastPosX;
                  posX = lastMinX;
                  console.log("AFTER ", lastMinX);
                }
                if (square.getBoundingClientRect().right > rightXLimit) {
                  lastPosX = posX - 1;
                  lastMaxX = lastPosX;
                  posX = lastMaxX;
                }
                if (square.getBoundingClientRect().top < topYLimit) {
                  lastMinY = lastPosY + 1;
                  lastMinY = lastPosY;
                }
                if (square.getBoundingClientRect().bottom > bottomYLimit) {
                  lastPosY = posY - 1;
                  lastMaxY = lastPosY;
                  posY = lastMaxY;
                }
              }
              break;
            case 'transform':
              scale = e.gesture.scale * lastScale;
              lastMaxX = 0;
              lastMinX = void 0;
              lastMaxY = 0;
              break;
            case 'dragend':
              lastPosX = posX;
              lastPosY = posY;
              lastScale = scale;
          }
          transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ';
          e.target.style.transform = transform + " " + match[0];
          return e.target.style.webkitTransform = e.target.style.transform + " " + match[0];
        }), $element[0]);
      });
    }
  };
});

angular.module('starter.directives', []).directive('ionPpinchh', function($timeout) {
  return {
    restrict: 'E',
    link: function($scope, $element, attrs) {
      if ($element[0].classList[0] !== "square") {
        return;
      }
      return $timeout(function() {
        var bottomYLimit, bufferX, bufferY, dragReady, lastMaxX, lastMaxY, lastMinX, lastMinY, lastPosX, lastPosY, lastScale, last_rotation, leftXLimit, max, oldScale, posX, posY, rightXLimit, rotation, scale, square, topYLimit;
        square = $element[0];
        posX = 0;
        posY = 0;
        lastPosX = 0;
        lastPosY = 0;
        bufferX = 0;
        bufferY = 0;
        scale = 1;
        lastScale = void 0;
        rotation = 0;
        last_rotation = void 0;
        dragReady = 0;
        leftXLimit = 0;
        rightXLimit = 720;
        topYLimit = 197;
        bottomYLimit = 385;
        lastMaxX = 0;
        lastMinX = void 0;
        lastMaxY = 0;
        lastMinY = 0;
        max = 200;
        oldScale = 0;
        return ionic.onGesture('touch drag dragend transform', (function(e) {
          var curTransform, realLeft;
          e.gesture.srcEvent.preventDefault();
          e.gesture.preventDefault();
          switch (e.type) {
            case 'touch':
              lastScale = scale;
              break;
            case 'drag':
              posX = e.gesture.deltaX + lastPosX;
              break;
            case 'transform':
              scale = e.gesture.scale * lastScale;
              break;
            case 'dragend':
              lastScale = scale;
              lastPosX = posX;
          }
          square.style.left = String(posX) + "px";
          curTransform = new WebKitCSSMatrix(window.getComputedStyle(e.target).webkitTransform);
          realLeft = e.target.offsetLeft + curTransform.m41;
          if (realLeft <= document.getElementById("panorama_image").getBoundingClientRect().left) {
            return e.target.style.left = String(document.getElementById("panorama_image").getBoundingClientRect().left) + "px";
          }
        }), $element[0]);
      });
    }
  };
});

var current_server;

current_server = "http://localhost:3000";

angular.module('starter.services', []).factory('Buildings', function() {
  var models;
  models = [
    {
      id: 1,
      name: "200 Massachusetts",
      code: "200M"
    }, {
      id: 2,
      name: "250 Massachusetts",
      code: "250M"
    }, {
      id: 3,
      name: "600 Second Street",
      code: "600"
    }, {
      id: 4,
      name: "201 F Street",
      code: "201F"
    }, {
      id: 5,
      name: "200 F Street",
      code: "200F"
    }
  ];
  return {
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    get: function(chatId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(chatId)) {
          return models[i];
        }
        i++;
      }
      return null;
    },
    buildingCode: function(name) {
      if (name === "201") {
        return "201F";
      }
      if (name === "600") {
        return "600";
      } else {
        return name;
      }
    }
  };
}).service('ActiveBuilding', function() {
  var actives, name, tabName;
  name = void 0;
  tabName = "SELECT BUILDING";
  actives = {};
  return {
    setName: function(new_name) {
      if (actives[new_name] === "active") {
        return actives[new_name] = void 0;
      } else {
        return actives[new_name] = "active";
      }
    },
    getName: function(new_name) {
      if (actives[new_name] === "active") {
        return true;
      } else {
        return false;
      }
    },
    isActive: function(q_name) {
      if (actives[q_name] === 'active') {
        return true;
      }
    },
    cancelAll: function() {
      var k, results, v;
      results = [];
      for (k in actives) {
        v = actives[k];
        results.push(actives[k] = void 0);
      }
      return results;
    }
  };
}).service('ActiveCrestron', function() {
  var actives, name, tabName;
  name = void 0;
  tabName = "SELECT BUILDING";
  actives = {};
  return {
    setName: function(new_name) {
      if (actives[new_name] === "active") {
        return actives[new_name] = void 0;
      } else {
        return actives[new_name] = "active";
      }
    },
    getName: function(new_name) {
      if (actives[new_name] === "active") {
        return true;
      } else {
        return false;
      }
    },
    isActive: function(q_name) {
      if (actives[q_name] === 'active') {
        return true;
      }
    },
    cancelAll: function() {
      var k, results, v;
      results = [];
      for (k in actives) {
        v = actives[k];
        results.push(actives[k] = void 0);
      }
      return results;
    },
    setAll: function() {
      actives['200 Massachusetts'] = 'active';
      actives['250 Massachusetts'] = 'active';
      actives['600 Second Street'] = 'active';
      actives['201 F Street'] = 'active';
      return actives['200 F Street'] = 'active';
    }
  };
}).factory('Presentations', function() {
  var models;
  models = [
    {
      id: 1,
      name: "Overview Presentation",
      image: 'img/assets/presentations/1.png',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 2,
      name: "Sustainability Presentation",
      image: 'img/assets/presentations/2.jpg',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 3,
      name: "Building Presentation",
      image: 'img/assets/presentations/3.jpg',
      building_name: '250 Massachusetts',
      project_name: "250 Massachusetts"
    }, {
      id: 4,
      name: "Overview Presentation",
      image: 'img/assets/presentations/1.png',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 5,
      name: "Sustainability Presentation",
      image: 'img/assets/presentations/2.jpg',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 6,
      name: "Building Presentation",
      image: 'img/assets/presentations/3.jpg',
      building_name: '250 Massachusetts',
      project_name: "250 Massachusetts"
    }, {
      id: 7,
      name: "Overview Presentation",
      image: 'img/assets/presentations/1.png',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 8,
      name: "Sustainability Presentation",
      image: 'img/assets/presentations/2.jpg',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 9,
      name: "Building Presentation",
      image: 'img/assets/presentations/3.jpg',
      building_name: '250 Massachusetts',
      project_name: "250 Massachusetts"
    }, {
      id: 10,
      name: "Overview Presentation",
      image: 'img/assets/presentations/1.png',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 11,
      name: "Sustainability Presentation",
      image: 'img/assets/presentations/2.jpg',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 12,
      name: "Building Presentation",
      image: 'img/assets/presentations/3.jpg',
      building_name: '250 Massachusetts',
      project_name: "250 Massachusetts"
    }, {
      id: 13,
      name: "Overview Presentation",
      image: 'img/assets/presentations/1.png',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 14,
      name: "Sustainability Presentation",
      image: 'img/assets/presentations/2.jpg',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 15,
      name: "Building Presentation",
      image: 'img/assets/presentations/3.jpg',
      building_name: '250 Massachusetts',
      project_name: "250 Massachusetts"
    }, {
      id: 16,
      name: "Overview Presentation",
      image: 'img/assets/presentations/1.png',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 17,
      name: "Sustainability Presentation",
      image: 'img/assets/presentations/2.jpg',
      building_name: '200 Massachusetts',
      project_name: "200 Massachusetts"
    }, {
      id: 18,
      name: "Building Presentation",
      image: 'img/assets/presentations/3.jpg',
      building_name: '250 Massachusetts',
      project_name: "250 Massachusetts"
    }, {
      id: 19,
      name: "Building Presentation",
      image: 'img/assets/presentations/3.jpg',
      building_name: '600 Second Street',
      project_name: "600 Second Street"
    }
  ];
  return {
    name: function() {
      return "Presentation";
    },
    sorted: function() {
      var hash, i, k, result, v;
      hash = {};
      result = [];
      i = 0;
      while (i < models.length) {
        if (hash[models[i].building_name] === void 0) {
          hash[models[i].building_name] = [models[i]];
        } else {
          hash[models[i].building_name].push(models[i]);
        }
        i++;
      }
      for (k in hash) {
        v = hash[k];
        result.push(v);
      }
      return result;
    },
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    get: function(chatId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(chatId)) {
          return models[i];
        }
        i++;
      }
      return null;
    },
    getSlides: function(presentationId) {
      var slides;
      return slides = [
        {
          id: 1,
          image: 'img/assets/slides/1.jpg'
        }, {
          id: 2,
          image: 'img/assets/slides/2.jpg'
        }, {
          id: 3,
          image: 'img/assets/slides/3.jpg'
        }, {
          id: 4,
          image: 'img/assets/slides/4.jpg'
        }, {
          id: 5,
          image: 'img/assets/slides/5.jpg'
        }, {
          id: 6,
          image: 'img/assets/slides/6.jpg'
        }, {
          id: 7,
          image: 'img/assets/slides/7.jpg'
        }, {
          id: 8,
          image: 'img/assets/slides/8.jpg'
        }, {
          id: 9,
          image: 'img/assets/slides/9.jpg'
        }, {
          id: 10,
          image: 'img/assets/slides/10.jpg'
        }
      ];
    }
  };
}).factory('Renderings', function($http, Buildings) {
  var models;
  models = [
    {
      id: 1,
      name: "Rend1",
      image: 'img/assets/renderings/1.jpg',
      building_name: '200 Massachusetts'
    }, {
      id: 2,
      name: "Rend2",
      image: 'img/assets/renderings/2.jpg',
      building_name: '200 Massachusetts'
    }, {
      id: 3,
      name: "Rendering 3",
      image: 'img/assets/renderings/3.jpg',
      building_name: '250 Massachusetts'
    }
  ];
  return {
    name: function() {
      return "Rendering";
    },
    sorted: function() {
      var hash, i, k, result, v;
      hash = {};
      result = [];
      i = 0;
      while (i < models.length) {
        if (hash[models[i].building_name] === void 0) {
          hash[models[i].building_name] = [models[i]];
        } else {
          hash[models[i].building_name].push(models[i]);
        }
        i++;
      }
      for (k in hash) {
        v = hash[k];
        result.push(v);
      }
      return result;
    },
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    get: function(chatId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(chatId)) {
          return models[i];
        }
        i++;
      }
      return null;
    }
  };
}).factory('Views', function() {
  var models;
  models = [
    {
      id: 1,
      name: "View1",
      image: 'img/assets/views/1.jpg',
      building_name: '200 Massachusetts',
      camera_name: '1'
    }, {
      id: 2,
      name: "View2",
      image: 'img/assets/views/2.jpg',
      building_name: '200 Massachusetts',
      camera_name: '2'
    }, {
      id: 3,
      name: "View3",
      image: 'img/assets/views/3.jpg',
      building_name: '250 Massachusetts',
      camera_name: '3'
    }
  ];
  return {
    name: function() {
      return "View";
    },
    sorted: function() {
      var hash, i, k, result, v;
      hash = {};
      result = [];
      i = 0;
      while (i < models.length) {
        if (hash[models[i].building_name] === void 0) {
          hash[models[i].building_name] = [models[i]];
        } else {
          hash[models[i].building_name].push(models[i]);
        }
        i++;
      }
      for (k in hash) {
        v = hash[k];
        result.push(v);
      }
      return result;
    },
    all: function() {
      var j, len, model, newMod;
      newMod = [];
      for (j = 0, len = models.length; j < len; j++) {
        model = models[j];
        model.id = Math.floor((Math.random() * 10) + 1);
        newMod.push(model);
      }
      return newMod;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    get: function(chatId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(chatId)) {
          return models[i];
        }
        i++;
      }
      return null;
    },
    getWebcamName: function(panId) {
      return models[0].camera_name;
    }
  };
}).factory('Floorplans', function() {
  var models;
  models = [
    {
      id: 1,
      name: "Floorplan1",
      image: 'img/assets/floorplans/1.svg',
      building_name: '200 Massachusetts'
    }, {
      id: 2,
      name: "Floorplan2",
      image: 'img/assets/floorplans/1.svg',
      building_name: '200 Massachusetts'
    }, {
      id: 3,
      name: "Floorplan3",
      image: 'img/assets/floorplans/3.svg',
      building_name: '250 Massachusetts'
    }
  ];
  return {
    name: function() {
      return "Floorplan";
    },
    sorted: function() {
      var hash, i, k, result, v;
      hash = {};
      result = [];
      i = 0;
      while (i < models.length) {
        if (hash[models[i].building_name] === void 0) {
          hash[models[i].building_name] = [models[i]];
        } else {
          hash[models[i].building_name].push(models[i]);
        }
        i++;
      }
      for (k in hash) {
        v = hash[k];
        result.push(v);
      }
      return result;
    },
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    get: function(chatId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(chatId)) {
          return models[i];
        }
        i++;
      }
      return null;
    }
  };
}).factory('Videos', function() {
  var models;
  models = [
    {
      id: 1,
      name: "Video1",
      image: 'img/assets/views/1.jpg',
      building_name: '200 Massachusetts',
      recording: 'img/assets/videos/1.mp4'
    }, {
      id: 2,
      name: "Video2",
      image: 'img/assets/views/2.jpg',
      building_name: '200 Massachusetts',
      recording: 'img/assets/videos/2.mp4'
    }, {
      id: 3,
      name: "Video3",
      image: 'img/assets/views/3.jpg',
      building_name: '250 Massachusetts',
      recording: 'img/assets/videos/3.mp4'
    }
  ];
  return {
    getRecording: function(videoId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(videoId)) {
          return models[i].recording;
        }
        i++;
      }
      return null;
    },
    name: function() {
      return "Video";
    },
    sorted: function() {
      var hash, i, k, result, v;
      hash = {};
      result = [];
      i = 0;
      while (i < models.length) {
        if (hash[models[i].building_name] === void 0) {
          hash[models[i].building_name] = [models[i]];
        } else {
          hash[models[i].building_name].push(models[i]);
        }
        i++;
      }
      for (k in hash) {
        v = hash[k];
        result.push(v);
      }
      return result;
    },
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    get: function(chatId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(chatId)) {
          return models[i];
        }
        i++;
      }
      return null;
    }
  };
}).factory('Timelapses', function() {
  var models;
  models = [
    {
      id: 1,
      name: "Timelapse 1",
      image: 'img/assets/views/1.jpg',
      building_name: '200 Massachusetts',
      recording: 'img/assets/videos/1.mp4'
    }, {
      id: 2,
      name: "Timelapse 2",
      image: 'img/assets/views/2.jpg',
      building_name: '200 Massachusetts',
      recording: 'img/assets/videos/2.mp4'
    }, {
      id: 3,
      name: "Timelapse 3",
      image: 'img/assets/views/3.jpg',
      building_name: '250 Massachusetts',
      recording: 'img/assets/videos/3.mp4'
    }
  ];
  return {
    getRecording: function(videoId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(videoId)) {
          return models[i].recording;
        }
        i++;
      }
      return null;
    },
    name: function() {
      return "Timelapse";
    },
    sorted: function() {
      var hash, i, k, result, v;
      hash = {};
      result = [];
      i = 0;
      while (i < models.length) {
        if (hash[models[i].building_name] === void 0) {
          hash[models[i].building_name] = [models[i]];
        } else {
          hash[models[i].building_name].push(models[i]);
        }
        i++;
      }
      for (k in hash) {
        v = hash[k];
        result.push(v);
      }
      return result;
    },
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    get: function(chatId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(chatId)) {
          return models[i];
        }
        i++;
      }
      return null;
    }
  };
}).service('ActiveCamera', function() {
  var name;
  name = void 0;
  return {
    setName: function(new_name) {
      return name = new_name;
    },
    getName: function(new_name) {
      return name;
    }
  };
}).factory('Webcams', function() {
  var models;
  models = [
    {
      id: 1,
      name: "Webcam1",
      image: 'img/assets/webcams/1.jpg',
      building_name: '200 Massachusetts'
    }, {
      id: 2,
      name: "Webcam2",
      image: 'img/assets/webcams/2.jpg',
      building_name: '200 Massachusetts'
    }, {
      id: 3,
      name: "Webcam3",
      image: 'img/assets/webcams/3.jpg',
      building_name: '250 Massachusetts'
    }
  ];
  return {
    name: function() {
      return "Webcam";
    },
    sorted: function() {
      var hash, i, k, result, v;
      hash = {};
      result = [];
      i = 0;
      while (i < models.length) {
        if (hash[models[i].building_name] === void 0) {
          hash[models[i].building_name] = [models[i]];
        } else {
          hash[models[i].building_name].push(models[i]);
        }
        i++;
      }
      for (k in hash) {
        v = hash[k];
        result.push(v);
      }
      return result;
    },
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    get: function(chatId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(chatId)) {
          return models[i];
        }
        i++;
      }
      return null;
    },
    getPanoramas: function(chatId) {
      return [
        {
          id: 1,
          name: "Panorama1",
          image: 'img/assets/panoramas/1.jpg'
        }, {
          id: 2,
          name: "Panorama2",
          image: 'img/assets/panoramas/2.jpg'
        }
      ];
    },
    getTimelapses: function(chatId) {
      return [
        {
          id: 1,
          name: "Video1",
          image: 'img/assets/webcams/1.jpg'
        }, {
          id: 2,
          name: "Video2",
          image: 'img/assets/webcams/2.jpg'
        }
      ];
    }
  };
}).factory('Panoramas', function() {
  var models;
  models = [
    {
      id: 1,
      name: "Pan1",
      image: 'img/assets/panoramas/1.jpg',
      building_name: '200 Massachusetts',
      camera_name: 'Camera 1'
    }
  ];
  return {
    name: function() {
      return "Panorama";
    },
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    get: function(chatId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(chatId)) {
          return models[i];
        }
        i++;
      }
      return null;
    },
    getWebcamName: function(panId) {
      return models[0].camera_name;
    }
  };
}).factory('TopmenuState', function() {
  var states;
  states = {
    buildings: true,
    comparisons: false
  };
  return {
    getBuildings: function() {
      return states.buildings;
    },
    getComparison: function() {
      return states.comparison;
    },
    setBuildings: function(st) {
      return states.buildings = st;
    },
    setComparison: function(st) {
      return states.comparison = st;
    }
  };
});
