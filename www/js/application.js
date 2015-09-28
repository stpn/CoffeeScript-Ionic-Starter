angular.module('starter', ['ionic', 'starter.controllers', 'starter.services', 'starter.filters', 'starter.directives']).run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);
    }
    if (window.StatusBar) {
      StatusBar.styleLightContent();
    }
  });
}).config(function($stateProvider, $urlRouterProvider) {
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
    url: '/presentations/:presentationId',
    views: {
      'tab-dash': {
        templateUrl: 'templates/presentations/presentation.html',
        controller: 'PresentationCtrl'
      }
    }
  }).state('tab.videos', {
    url: '/videos/:videoId',
    views: {
      'tab-dash': {
        templateUrl: 'templates/Videos/videoPlayer.html',
        controller: 'VideoPlayerCtrl'
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
  }).state('tab.panoramas', {
    url: '/panoramas/:panoramaId',
    views: {
      'webcams': {
        templateUrl: 'templates/panoramas/panorama.html',
        controller: 'PanoramasCtrl'
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
  $urlRouterProvider.otherwise('/tab/dash');
});

angular.module('starter.controllers', []).controller('DashCtrl', function($scope, $rootScope, $state, $log, Renderings, Views, Floorplans, Videos, Webcams, Presentations, ActiveBuilding, TopmenuState, Buildings) {
  $scope.presentations = {};
  $scope.factories = [["Presentations", Presentations.all()], ["Videos", Videos.all()], ["Floor Plans", Floorplans.all()], ["Rendering", Renderings.all()], ["Views", Views.all()], ["Webcams", Webcams.all()]];
  $scope.activeBuilding = ActiveBuilding;
  $scope.buldingTabName = "Select Buildings";
  $scope.state = $state;
  $scope.topMenu = TopmenuState.states;
  $scope.buildings = Buildings.all();
  $scope.templatePath = "templates/menu/building_menu.html";
  $scope.compTemplate = "templates/menu/comparison_menu.html";
  $scope.bld_style = "margin-top: 5px";
  $scope.transformStyle = "transform: scale(1.0)";
  $scope.topMenu = TopmenuState;
  $scope.isBuildings = function() {
    return TopmenuState.getBuildings();
  };
  $scope.isComparison = function() {
    return TopmenuState.getComparison();
  };
  $scope.showCompareMenu = function() {
    var menu, proceed;
    proceed = false;
    if (TopmenuState.getComparison() === true) {
      proceed = true;
      $scope.activeBuilding.tabName = $scope.activeBuilding.name;
    } else {
      $scope.activeBuilding.tabName = "COMPARISON MODE";
    }
    TopmenuState.setBuildings(false);
    TopmenuState.setComparison(true);
    menu = document.getElementById('ionTopMenu');
    if (menu.offsetHeight === 4 || proceed === true) {
      return $scope.toggleTopMenu();
    }
  };
  $scope.isActive = function(name) {
    return $scope.activeBuilding.isActive(name);
  };
  $scope.toggleGroup = function(group) {
    $log.debug($scope.activeBuilding.name, "NAME");
    if ($scope.isGroupShown(group)) {
      $scope.shownGroup = null;
    } else {
      $scope.shownGroup = group;
    }
  };
  $scope.isGroupShown = function(group) {
    return $scope.shownGroup === group;
  };
  $scope.openPres = function(presId) {
    window.location = '#/tab/presentations/' + presId;
    window.location.reload();
  };
  $scope.cancelActiveBuilding = function($event) {
    var bld_box;
    bld_box = document.getElementById('building_menu_wrap');
    bld_box = bld_box.getBoundingClientRect();
    $log.debug($event.clientX, $event.clientY, bld_box);
    if ($event.clientX > bld_box.left && $event.clientX < bld_box.right && $event.clientY > bld_box.top && $event.clientY < bld_box.bottom) {

    } else {
      $log.debug($event.clientX, $scope.activeBuilding.name);
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
  $scope.toggleTopMenu = function() {
    var bld, menu, pane;
    TopmenuState.setBuildings(true);
    TopmenuState.setComparison(false);
    bld = document.getElementById('building_wrap');
    menu = document.getElementById('ionTopMenu');
    pane = document.getElementsByTagName('ion-content')[0];
    if (menu.offsetHeight === 4) {
      menu.style.height = '250px';
      pane.style.top = '450px';
    } else {
      menu.style.height = '4px';
      pane.style.top = '120px';
    }
    if (menu.style.height === "4px") {
      $scope.bld_style = "margin-top: -200px";
    } else {
      $scope.bld_style = "margin-top: 50px";
    }
    if (TopmenuState.getBuildings() === false) {
      setTimeout((function() {
        TopmenuState.setBuildings(true);
        return TopmenuState.setComparison(false);
      }), 1000);
    }
  };
  return $scope.getFillColorFor = function(bld) {
    console.log(name, $scope.activeBuilding.getName() + " YESS");
    if ($scope.activeBuilding === void 0) {
      return "none";
    } else if (bld.name === $scope.activeBuilding.getName()) {
      console.log('yess');
      return "#6D6F72";
    } else {
      return "none";
    }
  };
}).controller('VideoDetailCtrl', function($scope, $stateParams, Videos) {
  $scope.video = Videos.get($stateParams.modelId);
}).controller('titleCtrl', function($scope, $stateParams) {
  $scope.titleTemplate = "templates/menu/title.html";
}).controller('FloorplanDetailCtrl', function($scope, $stateParams, Floorplans) {
  $scope.floorplan = Floorplans.get($stateParams.modelId);
}).controller('WebcamsCtrl', function($scope, $log, $stateParams, Webcams) {
  $scope.webcams = Webcams.all();
  $scope.activeWebcam = void 0;
  $scope.nowLive = false;
  $scope.isActive = function(item) {
    console.log($scope.activeWebcam);
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
    return $scope.timelapses = Webcams.getTimelapses(activeWebcamId);
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
    return $scope.nowLive = !$scope.nowLive;
  };
  $scope.toggleGroup = function(group) {
    if ($scope.isGroupShown(group)) {
      $scope.shownGroup = null;
    } else {
      $scope.shownGroup = group;
    }
  };
  $scope.isGroupShown = function(group) {
    return $scope.shownGroup === group;
  };
}).controller('PresentationCtrl', function($scope, $log, $stateParams, Presentations) {
  $scope.presentation = Presentations.get($stateParams.presentationId);
  $scope.slides = Presentations.getSlides($stateParams.presentationId);
  $scope.presentation_name = $scope.presentation.name;
  $scope.project_name = $scope.presentation.project_name;
  $scope.postSlide = function(slideId) {
    return $log.debug("FUCKYES " + slideId);
  };
  $scope.alertMe = function() {
    return $log.debug("FUCK");
  };
}).controller('VideoPlayerCtrl', function($scope, $sce, $log, $stateParams, Videos) {
  $scope.video = Videos.get($stateParams.videoId);
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
    console.log(name, $scope.activeBuilding.getName() + " YESS");
    if ($scope.activeBuilding === void 0) {
      return "none";
    } else if (bld.name === $scope.activeBuilding.getName()) {
      console.log('yess');
      return "#6D6F72";
    } else {
      return "none";
    }
  };
}).controller('PanoramasCtrl', function($scope, $stateParams, Panoramas, ActiveCamera, $ionicHistory) {
  $scope.panorama = Panoramas.get($stateParams.panoramaId);
  $scope.webcam_name = Panoramas.getWebcamName($stateParams.panoramaId);
  $scope.getPanorama = function() {
    return $scope.panorama.image;
  };
  return $scope.getCamera = function() {
    return 1;
  };
}).controller('TopMenuCtrl', function($scope, $sce, Buildings, ActiveBuilding, $log, $window, $location, TopmenuState) {
  $scope.activeBuilding = ActiveBuilding;
  $scope.buildings = Buildings.all();
  $scope.templatePath = "templates/menu/building_menu.html";
  $scope.compTemplate = "templates/menu/comparison_menu.html";
  $scope.bld_style = "margin-top: 5px";
  $scope.transformStyle = "transform: scale(1.0)";
  $scope.topMenu = TopmenuState;
  $scope.cancelActiveBuilding = function() {
    return ActiveBuilding.name = void 0;
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
    return $log.debug(name);
  };
  $scope.buildingCode = function(name) {
    if (name === "M201") {
      return "201";
    }
    if (name === "M600") {
      return "600";
    } else {
      return name;
    }
  };
  return $scope.toggleTopMenu = function() {
    var bld, menu, pane;
    bld = document.getElementById('building_wrap');
    menu = document.getElementById('ionTopMenu');
    pane = document.getElementsByTagName('ion-content')[0];
    if (menu.offsetHeight === 4) {
      menu.style.height = '350px';
      pane.style.top = '450px';
    } else {
      menu.style.height = '4px';
      pane.style.top = '120px';
    }
    if (menu.style.height === "4px") {
      $scope.bld_style = "margin-top: -200px";
    } else {
      $scope.bld_style = "margin-top: 50px";
    }
    if (TopmenuState.getBuildings() === false) {
      setTimeout((function() {
        TopmenuState.setBuildings(true);
        return TopmenuState.setComparison(false);
      }), 1000);
    }
  };
}).controller('VideoCtrl', function($scope, $stateParams, Videos) {
  $scope.video = Videos.get($stateParams.videoId);
  $scope.videoDiv = document.getElementById('video');
  $scope.seekBar = document.getElementById('seekbar');
  $scope.volume = document.getElementById('volume');
  $scope.skipValue = 0;
  $scope.videoDiv.addEventListener('timeupdate', function() {
    var value;
    value = (100 / $scope.videoDiv.duration) * $scope.videoDiv.currentTime;
    console.log(value);
    $scope.seekBar.value = value;
  });
  $scope.seekRelease = function() {
    var currentTime;
    currentTime = $scope.seekBar.value / (100 / $scope.videoDiv.duration);
    return $scope.videoDiv.currentTime = currentTime;
  };
  $scope.volumeUp = function() {
    console.log('UP');
    if ($scope.volume.value < 100) {
      return $scope.volume.value = $scope.volume.value + 5;
    } else {
      return $scope.volume.value = 100;
    }
  };
  $scope.volumeDown = function() {
    console.log('DOWN');
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
}).controller('ChatsCtrl', function($scope, Chats) {
  $scope.chats = Chats.all();
  $scope.remove = function(chat) {
    Chats.remove(chat);
  };
}).controller('ChatDetailCtrl', function($scope, $stateParams, Chats) {
  $scope.chat = Chats.get($stateParams.chatId);
}).controller('AccountCtrl', function($scope) {
  $scope.settings = {
    enableFriends: true
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

angular.module('starter.directives', []).directive('clickMe', function() {
  return {
    link: function($scope, element, iAttrs, controller) {
      console.log(element);
      element.bind('click', function() {
        console.log('I\'ve just been clicked!');
      });
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
          console.log("FUCK");
          console.log('$eval type:', scope.clickSvg);
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
        leftXLimit = 380;
        rightXLimit = 1060;
        fixPosXmin = 0;
        fixPosXmax = 300;
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
              if (square.getBoundingClientRect().left > leftXLimit && square.getBoundingClientRect().right < rightXLimit) {
                posX = e.gesture.deltaX / square.getBoundingClientRect().width * max + lastPosX;
                lastMaxX = posX;
                halt = false;
              } else {
                if (square.getBoundingClientRect().left === leftXLimit) {
                  fixPosXmin = e.gesture.deltaX / square.getBoundingClientRect().width * max + lastPosX;
                }
                if (square.getBoundingClientRect().left + square.getBoundingClientRect().width >= rightXLimit && halt === false) {
                  fixPosXmax = lastMaxX;
                  halt = true;
                }
              }
              if (fixPosXmin > e.gesture.deltaX / square.getBoundingClientRect().width * max + lastPosX) {
                posX = fixPosXmin;
              }
              if (e.gesture.deltaX / square.getBoundingClientRect().width * max + lastPosX > 250) {
                posX = 250;
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
      name: "Massachusetts 200",
      code: "M200"
    }, {
      id: 2,
      name: "Massachusetts 250",
      code: "M250"
    }, {
      id: 3,
      name: "Massachusetts 600",
      code: "M600"
    }, {
      id: 4,
      name: "Massachusetts 201",
      code: "M201"
    }, {
      id: 5,
      name: "Fassachusetts 200",
      code: "F200"
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
      if (name === "M201") {
        return "201";
      }
      if (name === "M600") {
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
      image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg',
      building_name: 'Massachusetts 200',
      project_name: "Massachusetts 200"
    }, {
      id: 2,
      name: "Sustainability Presentation",
      image: 'https://capxing.s3.amazonaws.com/uploads/view/image/2/thumb_250Mass_view1.jpg',
      building_name: 'Massachusetts 250',
      project_name: "Massachusetts 250"
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
          image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
        }, {
          id: 2,
          image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
        }, {
          id: 3,
          image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
        }, {
          id: 4,
          image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
        }, {
          id: 5,
          image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
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
      image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg',
      building_name: 'Massachusetts 200'
    }, {
      id: 2,
      name: "Rend2",
      image: 'https://capxing.s3.amazonaws.com/uploads/view/image/2/thumb_250Mass_view1.jpg',
      building_name: 'Massachusetts 300'
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
      image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg',
      building_name: 'Massachusetts 200'
    }, {
      id: 2,
      name: "View2",
      image: 'https://capxing.s3.amazonaws.com/uploads/view/image/2/thumb_250Mass_view1.jpg',
      building_name: 'Massachusetts 200'
    }, {
      id: 1,
      name: "View1",
      image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg',
      building_name: 'Massachusetts 200'
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
      image: 'https://capxing.s3.amazonaws.com/uploads/floorplan/image/4/200M_FP_PH_2.svg',
      building_name: 'Massachusetts 200'
    }, {
      id: 2,
      name: "Floorplan2",
      image: 'https://capxing.s3.amazonaws.com/uploads/floorplan/image/4/200M_FP_PH_2.svg',
      building_name: 'Massachusetts 200'
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
      image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg',
      building_name: 'Massachusetts 200',
      recording: 'http://www.w3schools.com/html/mov_bbb.mp4 '
    }, {
      id: 2,
      name: "Video2",
      image: 'https://capxing.s3.amazonaws.com/uploads/view/image/2/thumb_250Mass_view1.jpg',
      building_name: 'Massachusetts 200',
      recording: 'http://www.w3schools.com/html/mov_bbb.mp4'
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
      image: 'https://oxblue.com/archive/517405af56b6a32dcbb7fb3b7373378e/2048x1536.jpg?1442798939',
      building_name: 'Massachusetts 200'
    }, {
      id: 2,
      name: "Webcam2",
      image: 'https://oxblue.com/archive/276b2472bc731684941f635b7d1c2009/2048x1536.jpg?1442798939',
      building_name: 'Massachusetts 200'
    }, {
      id: 3,
      name: "Webcam3",
      image: 'https://oxblue.com/archive/52785a2e10cf0eb8a0b097e04e35aeb5/2048x1536.jpg?1442798939',
      building_name: 'Massachusetts 200'
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
          name: "Video1",
          image: 'https://capxing.s3.amazonaws.com/uploads/panorama/image/15/4.jpg'
        }, {
          id: 2,
          name: "Video2",
          image: 'https://capxing.s3.amazonaws.com/uploads/panorama/image/16/4.jpg'
        }
      ];
    },
    getTimelapses: function(chatId) {
      return [
        {
          id: 1,
          name: "Video1",
          image: 'https://oxblue.com/archive/2a415640359473ad01cd8b83498f8eea/2048x1536.jpg?1442798939'
        }, {
          id: 2,
          name: "Video2",
          image: 'https://oxblue.com/archive/2a415640359473ad01cd8b83498f8eea/2048x1536.jpg?1442798939'
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
      image: 'https://capxing.s3.amazonaws.com/uploads/panorama/image/16/4.jpg',
      building_name: 'Massachusetts 200',
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
