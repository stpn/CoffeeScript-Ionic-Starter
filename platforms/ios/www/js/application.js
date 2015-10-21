angular.module('starter', ['ionic', 'starter.controllers', 'starter.services', 'starter.filters', 'starter.directives']).run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);
      StatusBar.hide();
    }
  });
}).config(function($stateProvider, $httpProvider, $urlRouterProvider, $ionicConfigProvider) {
  $httpProvider.defaults.useXDomain = true;
  delete $httpProvider.defaults.headers.common["X-Requested-With"];
  $httpProvider.defaults.headers.common = {};
  $httpProvider.defaults.headers.post = {};
  $httpProvider.defaults.headers.put = {};
  $httpProvider.defaults.headers.patch = {};
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
        controller: 'VideoCtrl'
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
    url: '/panoramas/:cameraId',
    views: {
      'webcams': {
        templateUrl: 'templates/panoramas/panorama.html',
        controller: 'PanoramasCtrl'
      }
    }
  }).state('tab.live', {
    url: '/live',
    views: {
      'webcams': {
        templateUrl: 'templates/webcams/live.html',
        controller: 'LiveCtrl'
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
  }).state('tab.renderings', {
    url: '/renderings/:id',
    views: {
      'tab-dash': {
        templateUrl: 'templates/renderings/rendering.html',
        controller: 'RenderingsCtrl'
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

angular.module('starter.controllers', []).controller('DashCtrl', function($scope, $q, $http, $rootScope, $state, $log, APIService, Renderings, Views, Floorplans, Videos, Webcams, Presentations, ActiveBuilding, TopmenuState, Buildings, Snapshots) {
  $scope.presentations = {};
  $scope.factories = [["Presentations"], ["Videos"], ["Floor Plans"], ["Renderings"], ["Views"]];
  $scope.snapshots = [["Webcams"]];
  angular.forEach([Presentations, Videos, Floorplans, Renderings, Views], function(factory, index) {
    console.log(factory, index);
    return factory.sorted().then(function(reports) {
      return $scope.factories[index].push(reports);
    });
  });
  Snapshots.sorted().then(function(reports) {
    $scope.snapshots[0].push(reports);
  });
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
  $scope.showCompareMenu = function(name) {
    var bld, menu, pane;
    if (name === "Presentations" || name === "Videos" || name === "Views") {
      return;
    }
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
  $scope.getComparisonStroke = function(comparison) {
    if (comparison === $scope.activeComparison) {
      return "#FFF";
    } else {
      return "#808080";
    }
  };
  $scope.playAsset = function(name, asset) {
    var command;
    console.log(asset, name, "NAAME");
    if (name === "Presentations") {
      $scope.openLoc('presentations', asset.id);
      return;
    } else if (name === "Views") {
      $scope.openLoc('views', asset.id);
      return;
    } else if (name === "Videos") {
      $scope.openLoc('videos', asset.id);
      return;
    } else {
      command = {
        command: "play"
      };
    }
    return APIService.play(asset, name, command);
  };
  return $scope.openLoc = function(location, modId) {
    $state.go('tab.' + location, {
      id: modId
    }, {});
  };
}).controller('titleCtrl', function($scope, $stateParams) {
  $scope.titleTemplate = "templates/menu/title.html";
  $scope.home = '#/tab/home';
  $scope.dash = "#/tab/dash";
  $scope.buildings = "#/tab/buildings";
}).controller('FloorplanDetailCtrl', function($scope, $stateParams, Floorplans) {
  $scope.floorplan = Floorplans.get($stateParams.id);
}).controller('WebcamsCtrl', function($scope, $state, $log, Webcams, Timelapses) {
  $scope.activeWebcam = void 0;
  $scope.nowLive = false;
  $scope.nowLive4 = false;
  $scope.activeWebcamId = void 0;
  Webcams.all().then(function(reports) {
    $scope.webcams = reports;
  });
  $scope.noPano = function() {
    if ($scope.activeWebcam) {
      if ($scope.activeWebcam.panoramas_count === 0) {
        return true;
      }
    } else {
      return true;
    }
  };
  $scope.viewPano = function() {
    if ($scope.activeWebcam) {
      if ($scope.activeWebcam.panoramas_count === 0) {
        return 1;
      } else {
        return $state.go('tab.panoramas', {
          cameraId: $scope.activeWebcamId
        });
      }
    }
  };
  $scope.isActive = function(item) {
    if ($scope.activeWebcam === void 0) {
      return false;
    } else if ($scope.activeWebcam.id === item.id) {
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
  $scope.setActiveWebcam = function(activeWebcam) {
    $scope.activeWebcamId = activeWebcam.id;
    $scope.activeWebcam = Webcams.getLocal($scope.activeWebcamId);
    $scope.nowLive = false;
    $scope.nowLive4 = false;
    $scope.nowPano = false;
    Timelapses.getForCamera($scope.activeWebcamId).then(function(timelapses) {
      return $scope.timelapses = timelapses;
    });
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
    $scope.resetEverything();
    $scope.nowLive4 = false;
    return $state.go("tab.live", {}, {});
  };
  $scope.setLive4 = function() {
    $scope.nowLive4 = !$scope.nowLive4;
    $scope.resetEverything();
    return $scope.nowLive = false;
  };
  $scope.resetEverything = function() {
    $scope.activeWebcam = void 0;
    $scope.activeWebcamId = void 0;
    $scope.timelapses = void 0;
    return $scope.shownGroup = null;
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
  $scope.currentSlide = 1;
  Presentations.get($stateParams.id).then(function(result) {
    $scope.presentation = result;
    $scope.slides = $scope.presentation.slides;
    $scope.presentation_name = $scope.presentation.name;
    return $scope.project_name = $scope.presentation.building_name;
  });
  return $scope.postSlide = function(slideIdx) {
    if (slideIdx >= $scope.slides.length) {
      return $scope.currentSlide = $scope.slides.length;
    } else if (slideIdx <= 1) {
      return $scope.currentSlide = 1;
    } else {
      return $scope.currentSlide = slideIdx;
    }
  };
}).controller('VideoPlayerCtrl', function($scope, $sce, $log, $stateParams, Videos) {
  $scope.video = Videos.get($stateParams.id);
  $scope.recording = $sce.trustAsResourceUrl($scope.video.recording.url);
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
  var changeScale, firstHeight, firstWidth, pan, posX, posY, square;
  $scope.currentZoom = 1.0;
  $scope.factoryName = "Panoramas";
  square = document.getElementById("square");
  posX = 0;
  posY = 0;
  pan = document.getElementById("panorama_image");
  firstWidth = square.getBoundingClientRect().width;
  firstHeight = square.getBoundingClientRect().height;
  Panoramas.get_by_camera($stateParams.cameraId).then(function(result) {
    var img;
    $scope.panorama = result;
    $scope.webcam_name = $scope.panorama.webcam_name;
    $scope.image_url = $scope.panorama.image.url;
    img = new Image();
    img.src = $scope.panorama.image.url;
    $scope.dimensions = {};
    $scope.dimensions.width = img.width;
    return $scope.dimensions.height = img.height;
  });
  changeScale = function() {
    var scaleToSend;
    scaleToSend = parseFloat(1.0);
    if (parseFloat($scope.currentZoom) > parseFloat(1.0)) {
      scaleToSend = parseFloat(parseFloat($scope.currentZoom) - 1);
    } else if (parseFloat($scope.currentZoom) < parseFloat(1.0)) {
      scaleToSend = parseFloat(parseFloat($scope.currentZoom) + 1);
    }
    console.log("NEW SCALE: ", parseFloat(scaleToSend));
    console.log("OLD SCALE: ", parseFloat($scope.currentZoom));
    return scaleToSend;
  };
  $scope.zoomIn = function(name) {
    var toZoom;
    console.log($scope.currentZoom);
    if ($scope.currentZoom <= 0.4) {
      return;
    }
    toZoom = document.getElementById(name);
    $scope.currentZoom = $scope.currentZoom - 0.2;
    toZoom.style.transfrom = "scale(" + $scope.currentZoom + ")";
    toZoom.style.webkitTransform = "scale(" + $scope.currentZoom + ")";
    return changeScale();
  };
  $scope.zoomOut = function(name) {
    var changeX, changeY, deltaHeight, deltaWidth, toZoom, transform;
    console.log($scope.currentZoom);
    if ($scope.currentZoom >= 1.0) {
      return;
    } else if ($scope.currentZoom <= 0.3) {
      return;
    }
    toZoom = document.getElementById(name);
    $scope.currentZoom = $scope.currentZoom + 0.2;
    deltaWidth = Math.abs(square.getBoundingClientRect().width - firstWidth);
    deltaHeight = Math.abs(square.getBoundingClientRect().height - firstHeight);
    transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' + " " + "scale(" + $scope.currentZoom + ")";
    toZoom.style.transform = transform;
    toZoom.style.webkitTransform = toZoom.style.transform;
    if (square.getBoundingClientRect().left <= pan.getBoundingClientRect().left) {
      posX = -deltaWidth / 2;
      changeX = true;
    }
    if (square.getBoundingClientRect().top <= pan.getBoundingClientRect().top) {
      posY = -deltaHeight / 2;
      changeY = true;
    }
    if (square.getBoundingClientRect().right >= pan.getBoundingClientRect().right) {
      posX = pan.offsetWidth - square.getBoundingClientRect().width - deltaWidth / 2;
      changeX = true;
    }
    if (square.getBoundingClientRect().bottom >= pan.getBoundingClientRect().bottom) {
      posY = pan.offsetHeight - square.getBoundingClientRect().height - deltaHeight / 2;
      changeY = true;
    }
    if (changeX === true || changeY === true) {
      transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' + " " + "scale(" + $scope.currentZoom + ")";
      toZoom.style.transform = transform;
      toZoom.style.webkitTransform = toZoom.style.transform;
      changeX = false;
      changeY = false;
    }
    return changeScale();
  };
  $scope.getPanorama = function() {
    return $scope.panorama.image;
  };
  return $scope.getCamera = function() {
    return 1;
  };
}).controller('VideoCtrl', function($scope, $sce, $log, $stateParams, Videos, $location) {
  $scope.videoDiv = document.getElementById('video');
  $scope.seekBar = document.getElementById('seekbar');
  $scope.volume = document.getElementById('volume');
  $scope.skipValue = 0;
  $scope.mute = false;
  $scope.max = 80;
  $scope.videoState = true;
  Videos.get($stateParams.id).then(function(result) {
    $scope.video = result;
    console.log($scope.video.recording.url, "URL");
    $scope.recording = $sce.trustAsResourceUrl($scope.video.recording.url);
    return $scope.building_name = $scope.video.building_name;
  });
  $scope.trustSrc = function(src) {
    return $scope.videos = $sce.getTrustedResourceUrl(src);
  };
  $scope.postVideoId = function(videoId) {};
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
  $scope.videoDiv = document.getElementById('video');
  $scope.seekBar = document.getElementById('seekbar');
  $scope.volume = document.getElementById('volume');
  $scope.skipValue = 0;
  $scope.mute = false;
  $scope.max = 80;
  $scope.videoState = true;
  $scope.video = Timelapses.getLocal($stateParams.id);
  console.log($scope.video.recording.url, "URL");
  $scope.recording = $sce.trustAsResourceUrl($scope.video.recording.url);
  $scope.building_name = $scope.video.building_name;
  $scope.trustSrc = function(src) {
    return $scope.videos = $sce.getTrustedResourceUrl(src);
  };
  $scope.postVideoId = function(videoId) {};
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
  return $scope.progressRelease = function($event) {
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
}).controller('LiveCtrl', function($scope) {
  $scope.arrow_template = "templates/webcams/arrow.html";
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
  var firstHeight, firstWidth, pan, posX, posY, square;
  $scope.currentZoom = 1.0;
  square = document.getElementById("square");
  posX = 0;
  posY = 0;
  pan = document.getElementById("panorama_image");
  firstWidth = square.getBoundingClientRect().width;
  firstHeight = square.getBoundingClientRect().height;
  $scope.factoryName = "Views";
  Views.get($stateParams.id).then(function(result) {
    $scope.view = result;
    $scope.building_name = $scope.view.building_name;
    return $scope.imageUrl = $scope.view.image.url;
  });
  $scope.zoomIn = function(name) {
    var scaleToSend, toZoom;
    console.log($scope.currentZoom);
    if ($scope.currentZoom <= 0.4) {
      return;
    }
    toZoom = document.getElementById(name);
    $scope.currentZoom = $scope.currentZoom - 0.2;
    toZoom.style.transfrom = "scale(" + $scope.currentZoom + ")";
    toZoom.style.webkitTransform = "scale(" + $scope.currentZoom + ")";
    scaleToSend = 1;
    if (parseFloat($scope.currentZoom) > 1) {
      scaleToSend = parseFloat($scope.currentZoom) - 1;
    } else if (parseFloat($scope.currentZoom) > 1) {
      scaleToSend = parseFloat($scope.currentZoom) + 1;
    }
    console.log("NEW SCALE: ", parseFloat(scaleToSend));
    return console.log("OLD SCALE: ", parseFloat($scope.currentZoom));
  };
  $scope.zoomOut = function(name) {
    var changeX, changeY, deltaHeight, deltaWidth, scaleToSend, toZoom, transform;
    console.log($scope.currentZoom);
    if ($scope.currentZoom >= 1.0) {
      return;
    }
    toZoom = document.getElementById(name);
    $scope.currentZoom = $scope.currentZoom + 0.2;
    deltaWidth = Math.abs(square.getBoundingClientRect().width - firstWidth);
    deltaHeight = Math.abs(square.getBoundingClientRect().height - firstHeight);
    transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' + " " + "scale(" + $scope.currentZoom + ")";
    toZoom.style.transform = transform;
    toZoom.style.webkitTransform = toZoom.style.transform;
    if (square.getBoundingClientRect().left <= pan.getBoundingClientRect().left) {
      posX = -deltaWidth / 2;
      changeX = true;
    }
    if (square.getBoundingClientRect().top <= pan.getBoundingClientRect().top) {
      posY = -deltaHeight / 2;
      changeY = true;
    }
    if (square.getBoundingClientRect().right >= pan.getBoundingClientRect().right) {
      posX = pan.offsetWidth - square.getBoundingClientRect().width - deltaWidth / 2;
      changeX = true;
    }
    if (square.getBoundingClientRect().bottom >= pan.getBoundingClientRect().bottom) {
      posY = pan.offsetHeight - square.getBoundingClientRect().height - deltaHeight / 2;
      changeY = true;
    }
    if (changeX === true || changeY === true) {
      transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' + " " + "scale(" + $scope.currentZoom + ")";
      toZoom.style.transform = transform;
      toZoom.style.webkitTransform = toZoom.style.transform;
      changeX = false;
      changeY = false;
    }
    scaleToSend = 1;
    if (parseFloat($scope.currentZoom) > 1) {
      scaleToSend = parseFloat($scope.currentZoom) - 1;
    } else if (parseFloat($scope.currentZoom) > 1) {
      scaleToSend = parseFloat($scope.currentZoom) + 1;
    }
    console.log("NEW SCALE: ", parseFloat(scaleToSend));
    return console.log("OLD SCALE: ", parseFloat($scope.currentZoom));
  };
  $scope.getView = function() {
    return $scope.view.image;
  };
  return $scope.getCamera = function() {
    return 1;
  };
});

var scaleValues;

Number.prototype.map = function(in_min, in_max, out_min, out_max) {
  return (this - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
};

scaleValues = function(posY, posX, scale, img, imgname) {
  var command, h, pano_big, scaleToSend, screen, w, width_ratio, xToSend, yToSend;
  pano_big = 11532;
  screen = 7680;
  width_ratio = 1.5015625;
  w = 676;
  h = 190;
  scaleToSend = 1 / scale;
  xToSend = -(posX - 46).map(0, w, -0.25, 1.25);
  yToSend = 0;
  if (scale !== 0) {
    xToSend = -(posX - 46).map(0, w, -(scaleToSend * 0.75 - 0.5), scaleToSend * 0.75 + 0.5);
    yToSend = (posY - 178).map(0, h, -(scaleToSend * 0.5 - 0.5), scaleToSend * 0.5 + 0.5);
  }
  console.log("POS TO ORIGINAL " + posX + " " + posY);
  console.log("CUR POS : " + posX + " " + posY);
  console.log("TOUCH OLD SCALE: ", parseFloat(scale));
  console.log("TOUCH NEW SCALE: ", parseFloat(scaleToSend));
  console.log("POS TO SEND " + xToSend + " " + yToSend);
  command = {
    x: xToSend,
    y: yToSend,
    z: scaleToSend
  };
  return command;
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

angular.module('starter.directives', []).directive('ionPpinch', function($timeout, APIService) {
  return {
    restrict: 'E',
    scope: {
      image: '=',
      imgname: '=',
      dimensions: '='
    },
    link: function($scope, $element, attrs) {
      if ($element[0].classList[0] !== "square") {
        return;
      }
      return $timeout(function() {
        var bottomYLimit, bufferX, bufferY, changeX, changeY, cur_dim, deltaHeight, deltaWidth, dragReady, firstHeight, firstWidth, lastMaxX, lastMaxY, lastMinX, lastMinY, lastPosX, lastPosY, lastScale, last_rotation, leftXLimit, max, oldScale, oldWidth, orig_dim, pan, pass, posX, posY, rightXLimit, rotation, scale, scaleChange, square, topYLimit;
        pan = document.getElementById("panorama_image");
        console.log($scope.image, $scope.imgname);
        square = $element[0];
        firstWidth = square.getBoundingClientRect().width;
        firstHeight = square.getBoundingClientRect().height;
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
        topYLimit = 204;
        bottomYLimit = 390;
        lastMaxX = 0;
        lastMinX = 0;
        lastMaxY = 0;
        lastMinY = 0;
        max = 200;
        oldScale = 0;
        oldWidth = 0;
        pass = false;
        changeX = false;
        changeY = false;
        deltaHeight = 0;
        deltaWidth = 0;
        scaleChange = false;
        cur_dim = {
          width: 676,
          height: 186
        };
        orig_dim = $scope.dimensions;
        return ionic.onGesture('touch drag dragend transform release', (function(e) {
          var LastMinX, command, match, scalRgxp, transform;
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
              return console.log("TOUCH");
            case 'drag':
              console.log("DRAG");
              posX = e.gesture.deltaX / square.getBoundingClientRect().width * max + lastPosX;
              posY = e.gesture.deltaY / square.getBoundingClientRect().height * max + lastPosY;
              deltaWidth = Math.abs(square.getBoundingClientRect().width - firstWidth);
              deltaHeight = Math.abs(square.getBoundingClientRect().height - firstHeight);
              transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' + " " + match[0];
              e.target.style.transform = transform;
              e.target.style.webkitTransform = e.target.style.transform;
              if (square.getBoundingClientRect().left <= pan.getBoundingClientRect().left) {
                posX = -deltaWidth / 2;
                changeX = true;
              }
              if (square.getBoundingClientRect().top <= pan.getBoundingClientRect().top) {
                posY = -deltaHeight / 2;
                changeY = true;
              }
              if (square.getBoundingClientRect().right >= pan.getBoundingClientRect().right) {
                posX = pan.offsetWidth - square.getBoundingClientRect().width - deltaWidth / 2;
                changeX = true;
              }
              if (square.getBoundingClientRect().bottom >= pan.getBoundingClientRect().bottom) {
                posY = pan.offsetHeight - square.getBoundingClientRect().height - deltaHeight / 2;
                changeY = true;
              }
              if (changeX === true || changeY === true) {
                transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' + " " + match[0];
                e.target.style.transform = transform;
                e.target.style.webkitTransform = e.target.style.transform;
                changeX = false;
                return changeY = false;
              }
              break;
            case 'transform':
              scale = e.gesture.scale * lastScale;
              if (scale !== lastScale) {
                scaleChange = true;
              }
              if (scale > 1) {
                scale = 1;
              }
              deltaWidth = Math.abs(square.getBoundingClientRect().width - firstWidth);
              deltaHeight = Math.abs(square.getBoundingClientRect().height - firstHeight);
              transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' + " " + 'scale(' + scale + ')';
              e.target.style.transform = transform;
              e.target.style.webkitTransform = e.target.style.transform;
              if (square.getBoundingClientRect().left <= pan.getBoundingClientRect().left) {
                posX = -deltaWidth / 2;
                changeX = true;
              }
              if (square.getBoundingClientRect().top <= pan.getBoundingClientRect().top) {
                posY = -deltaHeight / 2;
                changeY = true;
              }
              if (square.getBoundingClientRect().right >= pan.getBoundingClientRect().right) {
                posX = pan.offsetWidth - square.getBoundingClientRect().width - deltaWidth / 2;
                changeX = true;
              }
              if (square.getBoundingClientRect().bottom >= pan.getBoundingClientRect().bottom) {
                posY = pan.offsetHeight - square.getBoundingClientRect().height - deltaHeight / 2;
                changeY = true;
              }
              if (changeX === true || changeY === true) {
                transform = 'translate3d(' + posX + 'px,' + posY + 'px, 0) ' + " " + 'scale(' + scale + ')';
                e.target.style.transform = transform;
                e.target.style.webkitTransform = e.target.style.transform;
                changeX = false;
                changeY = false;
              }
              command = scaleValues(square.getBoundingClientRect().top, square.getBoundingClientRect().left, scale, $scope.image, $scope.imgname);
              return APIService.panorama($scope.image, $scope.imgname, command);
            case 'dragend':
              lastPosX = posX;
              lastPosY = posY;
              return lastScale = scale;
            case 'release':
              command = scaleValues(square.getBoundingClientRect().top, square.getBoundingClientRect().left, scale, $scope.image, $scope.imgname);
              return APIService.panorama($scope.image, $scope.imgname, command);
          }
        }), $element[0]);
      });
    }
  };
});

var SERVER;

SERVER = "192.168.1.21";

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
}).service('HelperService', function(Buildings) {
  this.sort_models = function(models) {
    var hash, i, k, result, v;
    hash = {};
    result = [];
    i = 0;
    while (i < models.length) {
      if (models[i].building_name === void 0) {
        models[i].building_name = 'all';
      }
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
  };
  this.sort_snapshots = function(models) {
    var hash, i, k, result, v;
    hash = {};
    result = [];
    i = 0;
    while (i < models.length) {
      if (hash[models[i].camera_name] === void 0) {
        hash[models[i].camera_name] = [models[i]];
      } else {
        hash[models[i].camera_name].push(models[i]);
      }
      i++;
    }
    for (k in hash) {
      v = hash[k];
      result.push(v);
    }
    return result;
  };
}).service('APIService', function($http) {
  this.panorama = function(asset, name, command) {
    var json;
    name = name.substring(0, name.length - 1);
    json = {
      asset: {
        type: name,
        id: asset.id
      },
      command: {
        command: "pano"
      }
    };
    angular.extend(json.command, command);
    console.log("SENDING -> ", JSON.stringify(json));
    return $http.post('http://' + SERVER + "/pgs_command", json).then((function(response) {
      return console.log(response);
    }), function(data) {
      console.log(data);
    });
  };
  return;
  this.play = function(asset, name, command) {
    var json;
    json = {
      asset: {
        type: name,
        id: asset.id
      },
      command: {
        command: "play"
      }
    };
    angular.extend(json.command, command);
    return $http.post('http://' + SERVER + "/pgs_command", json).then((function(response) {
      return console.log(response);
    }), function(data) {
      console.log(data);
    });
  };
}).factory('Presentations', function($http, HelperService) {
  var models;
  models = [];
  return {
    name: function() {
      return "Presentation";
    },
    sorted: function() {
      return $http.get('http://' + SERVER + '/presentations.json').then((function(response) {
        var result;
        result = HelperService.sort_models(response.data);
        return result;
      }), function(data) {
        console.log(data, "ERROR PRES");
      });
    },
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    get: function(chatId) {
      return $http.get('http://' + SERVER + '/presentations/' + String(chatId) + '.json').then((function(response) {
        var result;
        console.log(response);
        result = response.data;
        return result;
      }), function(data) {
        console.log(data, "ERROR PRES");
      });
    },
    getLocal: function(camId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(camId)) {
          return models[i];
        }
        i++;
      }
      return null;
    }
  };
}).factory('Renderings', function($http, Buildings, HelperService) {
  var models;
  models = [];
  return {
    name: function() {
      return "Rendering";
    },
    sorted: function() {
      return $http.get('http://' + SERVER + '/renderings.json').then(function(response) {
        var result;
        result = HelperService.sort_models(response.data);
        return result;
      });
    },
    all: function() {
      return $http.get('http://' + SERVER + '/renderings.json').then(function(response) {
        console.log(response);
        models = response;
        return models;
      });
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    getLocal: function(camId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(camId)) {
          return models[i];
        }
        i++;
      }
      return null;
    }
  };
}).factory('Views', function($http, HelperService) {
  var models;
  models = [];
  return {
    name: function() {
      return "View";
    },
    sorted: function() {
      return $http.get('http://' + SERVER + '/views.json').then(function(response) {
        var result;
        result = HelperService.sort_models(response.data);
        return result;
      });
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
      return $http.get('http://' + SERVER + '/views/' + String(chatId) + '.json').then((function(response) {
        var result;
        result = response.data;
        return result;
      }), function(data) {
        console.log(data, "ERROR View");
      });
    },
    getLocal: function(camId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(camId)) {
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
}).factory('Floorplans', function($http, HelperService) {
  var models;
  models = [];
  return {
    name: function() {
      return "Floorplan";
    },
    sorted: function() {
      return $http.get('http://' + SERVER + '/floorplans.json').then(function(response) {
        var result;
        result = HelperService.sort_models(response.data);
        return result;
      });
    },
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    getLocal: function(camId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(camId)) {
          return models[i];
        }
        i++;
      }
      return null;
    }
  };
}).factory('Videos', function($http, HelperService) {
  var models;
  models = [];
  return {
    name: function() {
      return "Video";
    },
    sorted: function() {
      return $http.get('http://' + SERVER + '/videos.json').then((function(response) {
        var result;
        result = HelperService.sort_models(response.data);
        return result;
      }), function(data) {
        console.log(data, "ERROR PRES");
      });
    },
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    get: function(chatId) {
      return $http.get('http://' + SERVER + '/videos/' + String(chatId) + '.json').then((function(response) {
        var result;
        console.log(response);
        result = response.data;
        return result;
      }), function(data) {
        console.log(data, "ERROR Video");
      });
    },
    getLocal: function(camId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(camId)) {
          return models[i];
        }
        i++;
      }
      return null;
    }
  };
}).factory('Webcams', function($http, HelperService) {
  var models;
  models = [];
  return {
    name: function() {
      return "Webcam";
    },
    all: function() {
      return $http.get('http://' + SERVER + '/cameras.json').then((function(response) {
        console.log(response);
        models = response.data;
        return models;
      }), function(data) {
        console.log(data, "ERROR Cameras");
      });
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    },
    getLocal: function(camId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(camId)) {
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
    }
  };
}).factory('Timelapses', function($http) {
  var models;
  models = [];
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
    getForCamera: function(cameraId) {
      return $http.get('http://' + SERVER + '/timelapses_by_camera/' + cameraId + '.json').then((function(response) {
        models = response.data;
        return models;
      }), function(data) {
        console.log(data, "ERROR Timelapses");
      });
    },
    getLocal: function(camId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(camId)) {
          return models[i];
        }
        i++;
      }
      return null;
    },
    all: function() {
      return models;
    },
    remove: function(chat) {
      models.splice(models.indexOf(chat), 1);
    }
  };
}).service('Snapshots', function(HelperService, $http) {
  return {
    name: function() {
      return "Screenshot";
    },
    sorted: function() {
      return $http.get('http://' + SERVER + '/snapshots.json').then((function(response) {
        var result;
        result = HelperService.sort_snapshots(response.data);
        return result;
      }), function(data) {
        console.log(data, "ERROR Snapshot");
      });
    },
    get: function(chatId) {
      return $http.get('http://' + SERVER + '/snapshots/' + String(chatId) + '.json').then((function(response) {
        var result;
        console.log(response);
        result = response.data;
        return result;
      }), function(data) {
        console.log(data, "ERROR Snapshot");
      });
    },
    getLocal: function(camId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(camId)) {
          return models[i];
        }
        i++;
      }
      return null;
    }
  };
}).factory('Panoramas', function($http) {
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
    get_by_camera: function(camera_id) {
      return $http.get('http://' + SERVER + '/panorama_by_camera/' + String(camera_id) + '.json').then((function(response) {
        var result;
        console.log(response);
        result = response.data;
        return result;
      }), function(data) {
        console.log(data, "ERROR Panorama");
      });
    },
    getWebcamName: function(panId) {
      return models[0].camera_name;
    },
    getLocal: function(camId) {
      var i;
      i = 0;
      while (i < models.length) {
        if (models[i].id === parseInt(camId)) {
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
