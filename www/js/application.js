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

angular.module('starter.controllers', []).controller('DashCtrl', function($scope, $rootScope, $state, $log, Renderings, Views, Floorplans, Videos, Webcams, Presentations, ActiveBuilding) {
  $scope.presentations = {
    "Presentations": Presentations.all()
  };
  $scope.factories = {
    "Videos": Videos.all(),
    "Floor Plans": Floorplans.all(),
    "Rendering": Renderings.all(),
    "Views": Views.all(),
    "Webcams": Webcams.all()
  };
  $scope.activeBuilding = ActiveBuilding;
  $scope.state = $state;

  /*
   * if given group is the selected group, deselect it
   * else, select the given group
   */
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
  return $scope.openPres = function(presId) {
    window.location = '#/tab/presentations/' + presId;
    window.location.reload();
  };
}).controller('VideoDetailCtrl', function($scope, $stateParams, Videos) {
  $scope.video = Videos.get($stateParams.modelId);
}).controller('FloorplanDetailCtrl', function($scope, $stateParams, Floorplans) {
  $scope.floorplan = Floorplans.get($stateParams.modelId);
}).controller('WebcamsCtrl', function($scope, $log, $stateParams, Webcams) {
  $scope.webcams = Webcams.all();
  $scope.activeWebcam = void 0;
  $scope.setActiveWebcam = function(activeWebcamId) {
    $scope.activeWebcam = Webcams.get(activeWebcamId);
    $scope.panoramas = Webcams.getPanoramas(activeWebcamId);
    $scope.timelapses = Webcams.getTimelapses(activeWebcamId);
    return $log.debug($scope.panoramas);
  };
  $scope.isEnabled = function(model) {
    return model === void 0;
  };
  $scope.getActiveWebcam = function(activeWebcam) {
    return $scope.activeWebcam;
  };
  $scope.showPanorama = function() {
    return $log.debug("PANO");
  };
  $scope.showLive = function() {
    return $log.debug("LIVE");
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
}).controller('VideoDetailCtrl', function($scope, $stateParams, Presentations) {
  $scope.presentation = Presentations.get($stateParams.modelId);
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
  $scope.trustSrc = function(src) {
    return $scope.videos = $sce.getTrustedResourceUrl(src);
  };
  $scope.postVideoId = function(videoId) {
    return $log.debug("FUCKYES " + videoId);
  };
  $scope.alertMe = function() {
    return $log.debug("FUCK");
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
}).controller('BuildingsCtrl', function($scope, Buildings, $log) {
  $scope.buildings = Buildings.all();
  $scope.templatePath = "templates/menu/building_menu.html";
  $scope.transformStyle = "scale(1.19)";
  $scope.getTemplate = function(name) {
    return Buildings.getTemplate(name);
  };
  $scope.building_is = function(code, name) {
    if (code === name) {
      return true;
    }
  };
}).controller('TopMenuCtrl', function($scope, Buildings, ActiveBuilding, $log, $window, $location) {
  $scope.activeBuilding = ActiveBuilding;
  $scope.buildings = Buildings.all();
  $scope.templatePath = "templates/menu/building_menu.html";
  $scope.bld_style = "margin-top: 5px";
  $log.debug($location.url());
  $scope.transformStyle = "transform: scale(1.0)";
  $scope.building_is = function(code, name) {
    if (code === name) {
      return true;
    }
  };
  $scope.getTemplate = function(name) {
    return Buildings.getTemplate(name);
  };
  $scope.setActiveBuilding = function(name) {
    return $scope.activeBuilding.name = name;
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
  };
});

angular.module('starter.filters', []).filter('buildingFilter', [
  function() {
    return function(models, activeBuilding) {
      var tempClients;
      if (!angular.isUndefined(models) && !angular.isUndefined(activeBuilding) && activeBuilding.length > 0) {
        tempClients = [];
        angular.forEach(models, function(model) {
          if (angular.equals(model.building_name, activeBuilding)) {
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

angular.module('starter.directives', []).directive('clickMe', function($parse) {
  return function(scope, element, attrs) {
    element.bind('click', function() {
      var type;
      console.log('$eval type:', scope.$eval(attrs.clickMe));
      type = $parse(attrs.clickMe)(scope);
      console.log('$parse type:', type);
    });
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
          activeBuilding.setName(name);
          console.log(activeBuilding.getName());
        });
      }
    };
  }
]);

angular.module('starter.services', []).factory('Chats', function() {
  var chats;
  chats = [
    {
      id: 0,
      name: 'Ben Sparrow',
      lastText: 'You on your way?',
      face: 'https://pbs.twimg.com/profile_images/514549811765211136/9SgAuHeY.png'
    }, {
      id: 1,
      name: 'Max Lynx',
      lastText: 'Hey, it\'s me',
      face: 'https://avatars3.githubusercontent.com/u/11214?v=3&s=460'
    }, {
      id: 2,
      name: 'Adam Bradleyson',
      lastText: 'I should buy a boat',
      face: 'https://pbs.twimg.com/profile_images/479090794058379264/84TKj_qa.jpeg'
    }, {
      id: 3,
      name: 'Perry Governor',
      lastText: 'Look at my mukluks!',
      face: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png'
    }, {
      id: 4,
      name: 'Mike Harrington',
      lastText: 'This is wicked good ice cream.',
      face: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
    }
  ];
  return {
    all: function() {
      return chats;
    },
    remove: function(chat) {
      chats.splice(chats.indexOf(chat), 1);
    },
    get: function(chatId) {
      var i;
      i = 0;
      while (i < chats.length) {
        if (chats[i].id === parseInt(chatId)) {
          return chats[i];
        }
        i++;
      }
      return null;
    }
  };
}).factory('Buildings', function() {
  var models;
  models = [
    {
      id: 1,
      name: "Mass 200",
      code: "M200"
    }, {
      id: 2,
      name: "Mass 300",
      code: "M250"
    }, {
      id: 3,
      name: "Mass 200",
      code: "M600"
    }, {
      id: 4,
      name: "Mass 300",
      code: "M201"
    }, {
      id: 5,
      name: "Mass 200",
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
    }
  };
}).service('ActiveBuilding', function() {
  var name;
  name = "Mass 300";
  return {
    setName: function(new_name) {
      return name = new_name;
    },
    getName: function(new_name) {
      return name;
    }
  };
}).factory('Presentations', function() {
  var models;
  models = [
    {
      id: 1,
      name: "Pres1",
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png',
      building_name: 'Mass 200',
      project_name: "Mass 200"
    }, {
      id: 2,
      name: "Pres2",
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png',
      building_name: 'Mass 300',
      project_name: "Mass 300"
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
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
        }, {
          id: 2,
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
        }, {
          id: 3,
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
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
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png',
      building_name: 'Mass 200'
    }, {
      id: 2,
      name: "Rend2",
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png',
      building_name: 'Mass 300'
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
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png',
      building_name: 'Mass 200'
    }, {
      id: 2,
      name: "View2",
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png',
      building_name: 'Mass 200'
    }, {
      id: 1,
      name: "View1",
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png',
      building_name: 'Mass 200'
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
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png',
      building_name: 'Mass 200'
    }, {
      id: 2,
      name: "Floorplan2",
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png',
      building_name: 'Mass 200'
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
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png',
      building_name: 'Mass 200',
      recording: 'https://oxblue.com/pro/load_movie.php?sessionID=889de4dd7946bc7fe04d745d4b22ed56&camID=7376f96cdb760c6881df67a73af5b200 '
    }, {
      id: 2,
      name: "Video2",
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png',
      building_name: 'Mass 200',
      recording: 'http://oxblue.com/pro/load_movie.php?sessionID=889de4dd7946bc7fe04d745d4b22ed56&camID=7376f96cdb760c6881df67a73af5b200'
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
}).factory('Webcams', function() {
  var models;
  models = [
    {
      id: 1,
      name: "Webcam1",
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png',
      building_name: 'Mass 200'
    }, {
      id: 2,
      name: "Webcam2",
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png',
      building_name: 'Mass 200'
    }, {
      id: 3,
      name: "Webcam3",
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png',
      building_name: 'Mass 200'
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
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
        }, {
          id: 2,
          name: "Video2",
          image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png'
        }
      ];
    },
    getTimelapses: function(chatId) {
      return [
        {
          id: 1,
          name: "Video1",
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
        }, {
          id: 2,
          name: "Video2",
          image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png'
        }
      ];
    }
  };
});
