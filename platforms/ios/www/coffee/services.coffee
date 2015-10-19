angular.module('starter.services', []).factory('Buildings', ->
  models = [
    {
      id: 1
      name: "200 Massachusetts"
      code: "200M"
    },
    {
      id: 2
      name: "250 Massachusetts"
      code: "250M"
    },
    {
      id: 3
      name: "600 Second Street"
      code: "600"
    },
    {
      id: 4
      name: "201 F Street"
      code: "201F"
    },
    {
      id: 5
      name: "200 F Street"
      code: "200F"
    }
  ]
  {
    all: ->
      models
    remove: (chat) ->
      models.splice models.indexOf(chat), 1
      return
    get: (chatId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(chatId)
          return models[i]
        i++
      null

    buildingCode: (name)->    
      if name == "201"    
        return "201F"
      if name == "600"
        return "600"
      else
        return name      
  }

).service('HelperService', (Buildings) ->

  @sort_models = (models) ->
    hash = {}
    result = []
    i = 0  
    while i < models.length
      # bld_name = 'all'      
      # if  models[i].building_id
      #   bld_name =  Buildings.get(models[i].building_id).name
      if models[i].building_name == undefined
        models[i].building_name = 'all'
      # if models[i].image
      #   models[i].image.url = "http://localhost:3000/"+models[i].image.url
      if hash[models[i].building_name] == undefined
        hash[models[i].building_name] = [models[i]]
      else
        hash[models[i].building_name].push models[i]
      # if hash[models[i].building_name] == undefined
      #   hash[models[i].building_name] = [models[i]]
      # else
      #   hash[models[i].building_name].push(models[i])
      i++
    for k,v of hash
      result.push(v)    
    result


  @sort_snapshots = (models) ->
    hash = {}
    result = []
    i = 0  
    while i < models.length
      if hash[models[i].camera_name] == undefined
        hash[models[i].camera_name] = [models[i]]
      else
        hash[models[i].camera_name].push models[i]
      i++
    for k,v of hash
      result.push(v)    
    result    

  return



).service('APIService', ($http) ->

  server = "http://localhost:3000"


  # {:asset => {:type => "Rendering", :id => "23"},
  #  :command =>
  #  {:channel => "twelve",
  #   :screens => "12",
  #   :metadata1 => "Meta1", :metadata2 => "Meta2", :metadata3 => "Meta3", :metadata4 => "Meta4",
  #   :loction => 'left',
  #   :x => "1", :y => '2', :z => '3'
  #   }
  #  }

  @play = (asset, name, command) ->
    json =
      asset:
        type: name
        id: asset.id
      command: 
        command: "play"

    angular.extend(json.command, command)

    $http.post(server+"/pgs_command", json).then ((response) ->
      console.log response
      ), (data) ->
      console.log data
      return

  return



).factory('Presentations',($http, HelperService)  ->
  models = []

  {
    name: ->
     "Presentation"

    sorted: ->
      $http.get('http://localhost:3000/presentations.json').then ((response) ->        
        result = HelperService.sort_models(response.data)
        result
      ), (data) ->
        console.log data, "ERROR PRES"
        return

    all: ->
      models

    remove: (chat) ->
      models.splice models.indexOf(chat), 1
      return

    get: (chatId) ->
      $http.get('http://localhost:3000/presentations/'+String(chatId)+'.json').then ((response) ->        
        console.log response
        result = response.data
        result
      ), (data) ->
        console.log data, "ERROR PRES"
        return

    getLocal: (camId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(camId)
          return models[i]
        i++
      null

  }

).factory('Renderings', ($http, Buildings, HelperService) ->
  models = []

  {
    name: ->
     "Rendering"

    sorted: ->
      $http.get('http://localhost:3000/renderings.json').then (response) ->        
        result = HelperService.sort_models(response.data)
        result

    all: ->
      $http.get('http://localhost:3000/admin/renderings.json').then (response) ->
        console.log response
        models = response
        models

    remove: (chat) ->
      models.splice models.indexOf(chat), 1
      return

    getLocal: (camId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(camId)
          return models[i]
        i++
      null

  }
).factory('Views', ($http, HelperService) ->
  models = []
  {
    name: ->
     "View"  

    sorted: ->
      $http.get('http://localhost:3000/views.json').then (response) ->        
        result = HelperService.sort_models(response.data)
        result

    all: ->
      newMod = []
      for model in models
        model.id = Math.floor((Math.random()*10)+1);
        newMod.push(model)      
      newMod
    remove: (chat) ->
      models.splice models.indexOf(chat), 1
      return
    get: (chatId) ->
      $http.get('http://localhost:3000/views/'+String(chatId)+'.json').then ((response) ->        
        # console.log response
        result = response.data
        result
      ), (data) ->
        console.log data, "ERROR View"
        return

    getLocal: (camId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(camId)
          return models[i]
        i++
      null


    getWebcamName: (panId) ->
      models[0].camera_name


  }
).factory('Floorplans', ($http, HelperService)->
  models = []
  {
    name: ->
     "Floorplan"  

    sorted: ->
      $http.get('http://localhost:3000/floorplans.json').then (response) ->        
        result = HelperService.sort_models(response.data)
        result

    all: ->
      models
    remove: (chat) ->
      models.splice models.indexOf(chat), 1
      return

    getLocal: (camId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(camId)
          return models[i]
        i++
      null


  }
).factory('Videos', ($http, HelperService) ->
  models = []
  {

    name: ->
     "Video"

    sorted: ->
      $http.get('http://localhost:3000/videos.json').then ((response) ->        
        result = HelperService.sort_models(response.data)
        result
      ), (data) ->
        console.log data, "ERROR PRES"
        return        

    all: ->
      models
    remove: (chat) ->
      models.splice models.indexOf(chat), 1
      return
    get: (chatId) ->
      $http.get('http://localhost:3000/videos/'+String(chatId)+'.json').then ((response) ->        
        console.log response
        result = response.data
        result
      ), (data) ->
        console.log data, "ERROR Video"
        return

    getLocal: (camId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(camId)
          return models[i]
        i++
      null


  }

).factory('Webcams', ($http, HelperService) ->
  models = []
  {
    name: ->
     "Webcam"        

    # sorted: ->
    #   $http.get('http://localhost:3000/cameras.json').then (response) ->        
    #     result = HelperService.sort_models(response.data)
    #     result

    all: ->
      $http.get('http://localhost:3000/cameras.json').then ((response) ->        
        console.log response
        models = response.data
        models
      ), (data) ->
        console.log data, "ERROR Cameras"
        return

    remove: (chat) ->
      models.splice models.indexOf(chat), 1
      return

    getLocal: (camId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(camId)
          return models[i]
        i++
      null

    getPanoramas: (chatId) ->
      [
        {
          id: 1
          name: "Panorama1"
          image: 'img/assets/panoramas/1.jpg'
        },
        {
          id: 2
          name: "Panorama2"
          image: 'img/assets/panoramas/2.jpg'
        }    
      ]      

   

  }
).factory('Timelapses',($http) ->
  models = []
  {
    getRecording: (videoId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(videoId)
          return models[i].recording
        i++
      null

    name: ->
     "Timelapse"

    getForCamera: (cameraId) ->
      $http.get('http://localhost:3000/timelapses_by_camera/'+cameraId+'.json').then ((response) ->        
        models = response.data
        models
      ), (data) ->
        console.log data, "ERROR Timelapses"
        return   

    getLocal: (camId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(camId)
          return models[i]
        i++
      null

    all: ->
      models

    remove: (chat) ->
      models.splice models.indexOf(chat), 1
      return


  }

).service('Snapshots', (HelperService, $http) ->

    name: ->
     "Screenshot" 

    sorted: ->
      $http.get('http://localhost:3000/snapshots.json').then ((response) ->        
        result = HelperService.sort_snapshots(response.data)
        result
      ), (data) ->
        console.log data, "ERROR Snapshot"
        return        

    get: (chatId) ->
      $http.get('http://localhost:3000/snapshots/'+String(chatId)+'.json').then ((response) ->        
        console.log response
        result = response.data
        result
      ), (data) ->
        console.log data, "ERROR Snapshot"
        return

    getLocal: (camId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(camId)
          return models[i]
        i++
      null



).factory('Panoramas', ($http) ->
  models = [
    {
      id: 1
      name: "Pan1"
      image: 'img/assets/panoramas/1.jpg'
      building_name: '200 Massachusetts'
      camera_name: 'Camera 1'
    }    
  ]
  {
    name: ->
     "Panorama"
    all: ->
      models
    remove: (chat) ->
      models.splice models.indexOf(chat), 1
      return

    get_by_camera: (camera_id) ->
      $http.get('http://localhost:3000/panorama_by_camera/'+String(camera_id)+'.json').then ((response) ->        
        console.log response
        result = response.data
        result
      ), (data) ->
        console.log data, "ERROR Panorama"
        return

    getWebcamName: (panId) ->
      models[0].camera_name

    getLocal: (camId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(camId)
          return models[i]
        i++
      null


  }


).service('ActiveCamera', ->
  name = undefined

  {
    setName: (new_name) ->
      name = new_name

    getName: (new_name) ->
      name
  }

).service('ActiveBuilding', ->
  name = undefined
  tabName = "SELECT BUILDING"
  actives = {}

  {
    setName: (new_name) ->
      if actives[new_name] == "active"
        actives[new_name] = undefined
      else
        actives[new_name] = "active"


    getName: (new_name) ->
      if actives[new_name] == "active"
        return true
      else
        return false

    isActive: (q_name) ->
      if actives[q_name] == 'active'
        return true
    # getActive: ->
    #   if actives.size > 0
    #     for k,v of actives
    #       if actives[k] != undefined
    #         actives[k]
    cancelAll: ->
      for k,v of actives
        actives[k] = undefined


  }

).service('ActiveCrestron', ->
  name = undefined
  tabName = "SELECT BUILDING"
  actives = {}

  {
    setName: (new_name) ->
      if actives[new_name] == "active"
        actives[new_name] = undefined
      else
        actives[new_name] = "active"


    getName: (new_name) ->
      if actives[new_name] == "active"
        return true
      else
        return false

    isActive: (q_name) ->
      if actives[q_name] == 'active'
        return true

    cancelAll: ->
      for k,v of actives
        actives[k] = undefined
    
    setAll: ->
      actives['200 Massachusetts'] = 'active'
      actives['250 Massachusetts'] = 'active'
      actives['600 Second Street'] = 'active'
      actives['201 F Street'] = 'active'
      actives['200 F Street'] = 'active'
      

  }

).factory('TopmenuState', ->
  
  states =
    buildings: true
    comparisons: false


  {
    getBuildings:  ->
      states.buildings

    getComparison:  ->
      states.comparison


    setBuildings:(st)  ->
      states.buildings = st

    setComparison: (st) ->
      states.comparison = st


  }
)



# ---
# generated by js2coffee 2.1.0