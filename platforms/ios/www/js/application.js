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
  }).state('tab.home', {
    url: '/home',
    views: {
      'home': {
        templateUrl: 'templates/home.html',
        controller: 'HomeCtrl'
      }
    }
  }).state('tab.panoramas', {
    url: '/panoramas/:panoramaId',
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
  }).state('tab.chats', {
    url: '/chats',
    views: {
      'tab-chats': {
        templateUrl: 'templates/tab-chats.html',
        controller: 'ChatsCtrl'
      }
    }
  }).state('tab.chat-detail', {
    url: '/chats/:chatId',
    views: {
      'tab-chats': {
        templateUrl: 'templates/chat-detail.html',
        controller: 'ChatDetailCtrl'
      }
    }
  }).state('tab.account', {
    url: '/account',
    views: {
      'tab-account': {
        templateUrl: 'templates/tab-account.html',
        controller: 'AccountCtrl'
      }
    }
  });
  $urlRouterProvider.otherwise('/tab/home');
});

angular.module('starter.controllers', []).controller('DashCtrl', function($scope, $rootScope, $state, $log, Renderings, Views, Floorplans, Videos, Webcams, Presentations, ActiveBuilding, TopmenuState, Buildings) {
  $scope.presentations = {};
  $scope.factories = [["Presentations", Presentations.all()], ["Videos", Videos.all()], ["Floor Plans", Floorplans.all()], ["Rendering", Renderings.all()], ["Views", Views.all()], ["Webcams", Webcams.all()]];
  $scope.activeBuilding = ActiveBuilding;
  $scope.buldingTabName = "Select Buildings";
  $scope.comparisonState = false;
  $scope.buildings = Buildings.all();
  $scope.templatePath = "templates/menu/building_menu.html";
  $scope.compTemplate = "templates/menu/comparison_menu.html";
  $scope.bld_style = "margin-top: -200px";
  $scope.transformStyle = "transform: scale(1.0)";
  $scope.clicker_default = "63px";
  $scope.clicker_narrow = "43px";
  $scope.clicker_extranarrow = "16px";
  $scope.clicker_padding = $scope.clicker_default;
  $scope.accordionHeight = "0px";
  $scope.isComparison = function() {
    return $scope.comparisonState;
  };
  $scope.isActive = function(name) {
    return $scope.activeBuilding.isActive(name);
  };
  $scope.toggleGroup = function(group) {
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
      return $scope.setActiveBuilding(void 0);
    }
  };
  $scope.activeBuildingTabName = function() {
    if ($scope.activeBuilding.name === void 0) {
      return "SELECT BUILDING";
    } else {
      return $scope.activeBuilding.name;
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
    if (name === void 0) {
      $scope.activeBuilding.tabName = "SELECT BUILDING";
    }
    ActiveBuilding.setName(name);
    return $scope.activeBuilding.tabName = name;
  };
  $scope.buildingCode = function(name) {
    return Buildings.buildingCode(name);
  };
  $scope.toggleTopMenu = function(switchCompare) {
    var bld, menu, pane;
    $scope.comparisonState = false;
    bld = document.getElementById('building_wrap');
    menu = document.getElementById('ionTopMenu');
    pane = document.getElementsByTagName('ion-content')[0];
    if (menu.offsetHeight === 24) {
      menu.style.height = '250px';
      $scope.clicker_padding = $scope.clicker_narrow;
      pane.style.top = '320px';
    } else {
      menu.style.height = '24px';
      $scope.clicker_padding = $scope.clicker_default;
      pane.style.top = '85px';
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
      $scope.activeBuilding.tabName = "COMPARISON MODE";
      bld = document.getElementById('building_wrap');
      menu = document.getElementById('ionTopMenu');
      pane = document.getElementsByTagName('ion-content')[0];
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
  $scope.getFillColorFor = function(bld) {
    if ($scope.activeBuilding === void 0) {
      return "none";
    } else if (bld.name === $scope.activeBuilding.getName()) {
      return "#6D6F72";
    } else {
      return "none";
    }
  };
  return $scope.convertCode = function(name) {
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
}).controller('VideoDetailCtrl', function($scope, $stateParams, Videos) {
  $scope.video = Videos.get($stateParams.id);
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
  $scope.setActiveWebcam = function(activeWebcamId) {
    $scope.selected = activeWebcamId;
    $scope.activeWebcam = Webcams.get(activeWebcamId);
    $scope.panoramas = Webcams.getPanoramas(activeWebcamId);
    $scope.timelapses = Webcams.getTimelapses(activeWebcamId);
    $scope.nowLive = false;
    $scope.nowLive4 = false;
    return $scope.nowPano = false;
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
    if (slideIdx === $scope.slides.length) {
      $scope.currentSlide = $scope.slides.length;
    }
    if (slideIdx === 1) {
      return $scope.currentSlide = 1;
    } else {
      return $scope.currentSlide = slideIdx;
    }
  };
  $scope.alertMe = function() {
    return $log.debug("FUCK");
  };
}).controller('VideoPlayerCtrl', function($scope, $sce, $log, $stateParams, Videos) {
  $scope.video = Videos.get($stateParams.id);
  $scope.recording = $sce.trustAsResourceUrl($scope.video.recording);
  $scope.building_name = $scope.video.building_name;
  $scope.trustSrc = function(src) {
    return $scope.videos = $sce.getTrustedResourceUrl(src);
  };
  $scope.postVideoId = function(videoId) {
    return $log.debug("FUCKYES " + videoId);
  };
  $scope.alertMe = function() {
    return $log.debug("FUCK");
  };
}).controller('BuildingsCtrl', function($scope, Buildings, $log, ActiveBuilding) {
  $scope.buildings = Buildings.all();
  $scope.templatePath = "templates/menu/building_menu.html";
  $scope.transformStyle = "scale(1.19)";
  $scope.activeBuilding = ActiveBuilding;
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
    if (name === void 0) {
      $scope.activeBuilding.tabName = "SELECT BUILDING";
    }
    ActiveBuilding.setName(name);
    return $scope.activeBuilding.tabName = name;
  };
  $scope.getFillColorFor = function(bld) {
    if ((bld === "all" && "all" === $scope.activeBuilding.getName())) {
      return "#6D6F72";
    } else if ($scope.activeBuilding === void 0) {
      return "none";
    } else if (bld.name === $scope.activeBuilding.getName()) {
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
    return $scope.videoDiv.currentTime = currentTime;
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
      return $scope.videoDiv.play();
    } else {
      return $scope.videoDiv.pause();
    }
  };
}).controller('HomeCtrl', function($scope) {
  $scope.home = "HOME";
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

angular.module('starter.directives', []).directive('clickMe', function() {
  return {
    link: function($scope, element, iAttrs, controller) {
      element.bind('click', function() {});
    }
  };
});

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

angular.module('starter.directives', []).directive('ionPinch', function($timeout) {
  return {
    restrict: 'A',
    link: function($scope, $element, attrs) {
      $timeout(function() {
        var bufferX, bufferY, dragReady, fixPosXmax, fixPosXmin, halt, lastMaxX, lastPosX, lastPosY, lastScale, last_rotation, leftXLimit, max, posX, posY, rightXLimit, rotation, scale, square;
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
        leftXLimit = 340;
        rightXLimit = 1080;
        fixPosXmin = 0;
        fixPosXmax = 250;
        lastMaxX = 0;
        halt = false;
        max = 200;
        ionic.onGesture('touch drag transform dragend', (function(e) {
          var transform;
          e.gesture.srcEvent.preventDefault();
          e.gesture.preventDefault();
          switch (e.type) {
            case 'touch':
              lastScale = scale;
              last_rotation = rotation;
              break;
            case 'drag':
              posX = e.gesture.deltaX / square.getBoundingClientRect().width * max + lastPosX;
              console.log(posX);
              lastMaxX = posX;
              halt = false;
              if (posX > 249) {
                posX = 249;
              }
              if (posX <= 1) {
                posX = 2;
              }
              break;
            case 'transform':
              rotation = e.gesture.rotation + last_rotation;
              scale = e.gesture.scale * lastScale;
              break;
            case 'dragend':
              lastPosX = posX;
              lastScale = scale;
          }
          transform = 'translate3d(' + posX + 'px, 0px, 0) ' + 'scale(' + scale + ')' + 'rotate(' + rotation + 'deg) ';
          e.target.style.transform = transform;
          e.target.style.webkitTransform = transform;
        }), $element[0]);
      });
    }
  };
});

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
  var name, tabName;
  name = void 0;
  tabName = "SELECT BUILDING";
  return {
    setName: function(new_name) {
      return name = new_name;
    },
    getName: function(new_name) {
      return name;
    },
    isActive: function(q_name) {
      if (angular.equals(name, q_name) || name === void 0) {
        return true;
      } else {
        return false;
      }
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
    }
  ];
  return {
    name: function() {
      return "Presentation";
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
}).factory('Renderings', function() {
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
      building_name: '200 Massachusetts'
    }, {
      id: 2,
      name: "View2",
      image: 'img/assets/views/2.jpg',
      building_name: '200 Massachusetts'
    }, {
      id: 3,
      name: "View3",
      image: 'img/assets/views/3.jpg',
      building_name: '250 Massachusetts'
    }
  ];
  return {
    name: function() {
      return "View";
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
