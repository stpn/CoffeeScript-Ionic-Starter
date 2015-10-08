current_server  ="http://localhost:3000"
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
    # getActive: ->
    #   if actives.size > 0
    #     for k,v of actives
    #       if actives[k] != undefined
    #         actives[k]
    cancelAll: ->
      for k,v of actives
        actives[k] = undefined
  }

).factory('Presentations', ->
  models = [
    {
      id: 1
      name: "Overview Presentation"
      image: 'img/assets/presentations/1.png'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"
    },
    {
      id: 2
      name: "Sustainability Presentation"
      image: 'img/assets/presentations/2.jpg'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"      
    },
    {
      id: 3
      name: "Building Presentation"
      image: 'img/assets/presentations/3.jpg'
      building_name: '250 Massachusetts'
      project_name: "250 Massachusetts"      
    },
    {
      id: 4
      name: "Overview Presentation"
      image: 'img/assets/presentations/1.png'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"
    },
    {
      id: 5
      name: "Sustainability Presentation"
      image: 'img/assets/presentations/2.jpg'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"      
    },
    {
      id: 6
      name: "Building Presentation"
      image: 'img/assets/presentations/3.jpg'
      building_name: '250 Massachusetts'
      project_name: "250 Massachusetts"      
    },
    {
      id: 7
      name: "Overview Presentation"
      image: 'img/assets/presentations/1.png'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"
    },
    {
      id: 8
      name: "Sustainability Presentation"
      image: 'img/assets/presentations/2.jpg'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"      
    },
    {
      id: 9
      name: "Building Presentation"
      image: 'img/assets/presentations/3.jpg'
      building_name: '250 Massachusetts'
      project_name: "250 Massachusetts"      
    },
    {
      id: 10
      name: "Overview Presentation"
      image: 'img/assets/presentations/1.png'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"
    },
    {
      id: 11
      name: "Sustainability Presentation"
      image: 'img/assets/presentations/2.jpg'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"      
    },
    {
      id: 12
      name: "Building Presentation"
      image: 'img/assets/presentations/3.jpg'
      building_name: '250 Massachusetts'
      project_name: "250 Massachusetts"      
    },
    {
      id: 13
      name: "Overview Presentation"
      image: 'img/assets/presentations/1.png'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"
    },
    {
      id: 14
      name: "Sustainability Presentation"
      image: 'img/assets/presentations/2.jpg'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"      
    },
    {
      id: 15
      name: "Building Presentation"
      image: 'img/assets/presentations/3.jpg'
      building_name: '250 Massachusetts'
      project_name: "250 Massachusetts"      
    },
    {
      id: 16
      name: "Overview Presentation"
      image: 'img/assets/presentations/1.png'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"
    },
    {
      id: 17
      name: "Sustainability Presentation"
      image: 'img/assets/presentations/2.jpg'
      building_name: '200 Massachusetts'
      project_name: "200 Massachusetts"      
    },
    {
      id: 18
      name: "Building Presentation"
      image: 'img/assets/presentations/3.jpg'
      building_name: '250 Massachusetts'
      project_name: "250 Massachusetts"      
    },    
    {
      id: 19
      name: "Building Presentation"
      image: 'img/assets/presentations/3.jpg'
      building_name: '600 Second Street'
      project_name: "600 Second Street"      
    }
  ]
  {
    name: ->
     "Presentation"

    sorted: ->
      hash = {}
      result = []
      i = 0
      while i < models.length        
        if hash[models[i].building_name] == undefined
          hash[models[i].building_name] = [models[i]]
        else
          hash[models[i].building_name].push(models[i])
        i++
      for k,v of hash
        result.push(v)
      result

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
    getSlides: (presentationId) ->
      slides = [
        {
          id: 1
          image: 'img/assets/slides/1.jpg'
        },
        {
          id: 2
          image: 'img/assets/slides/2.jpg'
        },
        {
          id: 3
          image: 'img/assets/slides/3.jpg'
        },
        {
          id: 4
          image: 'img/assets/slides/4.jpg'
        },
        {
          id: 5
          image: 'img/assets/slides/5.jpg'
        },
        {
          id: 6
          image: 'img/assets/slides/6.jpg'
        },
        {
          id: 7
          image: 'img/assets/slides/7.jpg'
        },
        {
          id: 8
          image: 'img/assets/slides/8.jpg'
        },
        {
          id: 9
          image: 'img/assets/slides/9.jpg'
        },
        {
          id: 10
          image: 'img/assets/slides/10.jpg'
        }  
      ]

  }
).factory('Renderings', ($http, Buildings) ->
  models = [
    {
      id: 1
      name: "Rend1"
      image: 'img/assets/renderings/1.jpg'
      building_name: '200 Massachusetts'
    },
    {
      id: 2
      name: "Rend2"
      image: 'img/assets/renderings/2.jpg'
      building_name: '200 Massachusetts'
    },
    {
      id: 3
      name: "Rendering 3"
      image: 'img/assets/renderings/3.jpg'
      building_name: '250 Massachusetts'
    }    
 ]
  {
    name: ->
     "Rendering"

    sorted: ->
      hash = {}
      result = []
      i = 0
      while i < models.length        
        if hash[models[i].building_name] == undefined
          hash[models[i].building_name] = [models[i]]
        else
          hash[models[i].building_name].push(models[i])
        i++
      for k,v of hash
        result.push(v)
      result


    # sorted: ->
    #   hash = {}
    #   result = []
    #   i = 0
    #   $http.get('http://localhost:3000/renderings.json').then (response) ->
        
    #     models = response.data
    #     console.log models
    #     while i < models.length
    #       bld_name =  Buildings.get(models[i].building_id).name
    #       if hash[bld_name] == undefined
    #         hash[bld_name] = [models[i]]
    #       else
    #         hash[bld_name].push models[i]
    #       # if hash[models[i].building_name] == undefined
    #       #   hash[models[i].building_name] = [models[i]]
    #       # else
    #       #   hash[models[i].building_name].push(models[i])
    #       i++
    #     for k,v of hash
    #       result.push(v)    

    #     result


    all: ->
      # $http.get('http://localhost:3000/admin/renderings.json').then (response) ->
      #   console.log response
      #   models = response
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

  }
).factory('Views', ->
  models = [
    {
      id: 1
      name: "View1"
      image: 'img/assets/views/1.jpg'
      building_name: '200 Massachusetts'
      camera_name: '1'
    },
    {
      id: 2
      name: "View2"
      image: 'img/assets/views/2.jpg'
      building_name: '200 Massachusetts'
      camera_name: '2'
    },   
   {
      id: 3
      name: "View3"
      image: 'img/assets/views/3.jpg'
      building_name: '250 Massachusetts'
      camera_name: '3'
    }                               
  ]
  {
    name: ->
     "View"  

    sorted: ->
      hash = {}
      result = []
      i = 0
      while i < models.length
        
        if hash[models[i].building_name] == undefined
          hash[models[i].building_name] = [models[i]]
        else
          hash[models[i].building_name].push(models[i])
        i++
      for k,v of hash
        result.push(v)
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
      i = 0
      while i < models.length
        if models[i].id == parseInt(chatId)
          return models[i]
        i++
      null
    getWebcamName: (panId) ->
      models[0].camera_name


  }
).factory('Floorplans', ->
  models = [
    {
      id: 1
      name: "Floorplan1"
      image: 'img/assets/floorplans/1.svg'
      building_name: '200 Massachusetts'
    },
    {
      id: 2
      name: "Floorplan2"
      image: 'img/assets/floorplans/1.svg'
      building_name: '200 Massachusetts'
    },
    {
      id: 3
      name: "Floorplan3"
      image: 'img/assets/floorplans/3.svg'
      building_name: '250 Massachusetts'
    }        
  ]
  {
    name: ->
     "Floorplan"  

    sorted: ->
      hash = {}
      result = []
      i = 0
      while i < models.length
        
        if hash[models[i].building_name] == undefined
          hash[models[i].building_name] = [models[i]]
        else
          hash[models[i].building_name].push(models[i])
        i++
      for k,v of hash
        result.push(v)
      result

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

  }
).factory('Videos', ->
  models = [
    {
      id: 1
      name: "Video1"
      image: 'img/assets/views/1.jpg'
      building_name: '200 Massachusetts'
      recording: 'img/assets/videos/1.mp4'
    },
    {
      id: 2
      name: "Video2"
      image: 'img/assets/views/2.jpg'
      building_name: '200 Massachusetts'
      recording: 'img/assets/videos/2.mp4'
    },
    {
      id: 3
      name: "Video3"
      image: 'img/assets/views/3.jpg'
      building_name: '250 Massachusetts'
      recording: 'img/assets/videos/3.mp4'
    }    
  ]
  {
    getRecording: (videoId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(videoId)
          return models[i].recording
        i++
      null
    name: ->
     "Video"

    sorted: ->
      hash = {}
      result = []
      i = 0
      while i < models.length
        
        if hash[models[i].building_name] == undefined
          hash[models[i].building_name] = [models[i]]
        else
          hash[models[i].building_name].push(models[i])
        i++
      for k,v of hash
        result.push(v)
      result

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

  }

).service('ActiveCamera', ->
  name = undefined

  {
    setName: (new_name) ->
      name = new_name

    getName: (new_name) ->
      name
  }

).factory('Webcams', ->
  models = [
    {
      id: 1
      name: "Webcam1"
      image: 'img/assets/webcams/1.jpg'
      building_name: '200 Massachusetts'
    },
    {
      id: 2
      name: "Webcam2"
      image: 'img/assets/webcams/2.jpg'
      building_name: '200 Massachusetts'
    },
    {
      id: 3
      name: "Webcam3"
      image: 'img/assets/webcams/3.jpg'
      building_name: '250 Massachusetts'
    }   
  ]
  {
    name: ->
     "Webcam"        

    sorted: ->
      hash = {}
      result = []
      i = 0
      while i < models.length
        
        if hash[models[i].building_name] == undefined
          hash[models[i].building_name] = [models[i]]
        else
          hash[models[i].building_name].push(models[i])
        i++
      for k,v of hash
        result.push(v)
      result

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

    getTimelapses: (chatId) ->
      [
        {
          id: 1
          name: "Video1"
          image: 'img/assets/webcams/1.jpg'
        },
        {
          id: 2
          name: "Video2"
          image: 'img/assets/webcams/2.jpg'
        }    
      ] 
  }
).factory('Panoramas', ->
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
    get: (chatId) ->
      i = 0
      while i < models.length
        if models[i].id == parseInt(chatId)
          return models[i]
        i++
      null
    getWebcamName: (panId) ->
      models[0].camera_name

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