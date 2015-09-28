angular.module('starter.services', []).factory('Buildings', ->
  models = [
    {
      id: 1
      name: "Mass 200"
      code: "M200"
    },
    {
      id: 2
      name: "Mass 250"
      code: "M250"
    },
    {
      id: 3
      name: "Mass 600"
      code: "M600"
    },
    {
      id: 4
      name: "Mass 201"
      code: "M201"
    },
    {
      id: 5
      name: "Fass 200"
      code: "F200"
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
      if name == "M201"    
        return "201"
      if name == "M600"
        return "600"
      else
        return name      
  }
).service('ActiveBuilding', ->
  name = undefined

  {
    setName: (new_name) ->
      name = new_name

    getName: (new_name) ->
      name

    isActive: (q_name) ->
      if angular.equals(name,q_name) || name == undefined
        return true
      else 
        return false
  }

).factory('Presentations', ->
  models = [
    {
      id: 1
      name: "Overview Presentation"
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
      building_name: 'Mass 200'
      project_name: "Mass 200"
    },
    {
      id: 2
      name: "Sustainability Presentation"
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png'
      building_name: 'Mass 250'
      project_name: "Mass 250"      
    }    
  ]
  {
    name: ->
     "Presentation"
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
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
        },
        {
          id: 2
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
        },
        {
          id: 3
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
        },
        {
          id: 4
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
        },
        {
          id: 5
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
        }  
      ]

  }
).factory('Renderings', ->
  models = [
    {
      id: 1
      name: "Rend1"
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
      building_name: 'Mass 200'
    },
    {
      id: 2
      name: "Rend2"
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png'
      building_name: 'Mass 300'
    }    
  ]
  {
    name: ->
     "Rendering"
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
).factory('Views', ->
  models = [
    {
      id: 1
      name: "View1"
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
      building_name: 'Mass 200'
    },
    {
      id: 2
      name: "View2"
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png'
      building_name: 'Mass 200'
    },   
   {
      id: 1
      name: "View1"
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
      building_name: 'Mass 200'
    }                               
  ]
  {
    name: ->
     "View"    
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

  }
).factory('Floorplans', ->
  models = [
    {
      id: 1
      name: "Floorplan1"
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
      building_name: 'Mass 200'
    },
    {
      id: 2
      name: "Floorplan2"
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png'
      building_name: 'Mass 200'
    }    
  ]
  {
    name: ->
     "Floorplan"        
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
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
      building_name: 'Mass 200'
      recording: 'http://www.w3schools.com/html/mov_bbb.mp4 '
    },
    {
      id: 2
      name: "Video2"
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png'
      building_name: 'Mass 200'
      recording: 'http://www.w3schools.com/html/mov_bbb.mp4'
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
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
      building_name: 'Mass 200'
    },
    {
      id: 2
      name: "Webcam2"
      image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png'
      building_name: 'Mass 200'
    },
    {
      id: 3
      name: "Webcam3"
      image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
      building_name: 'Mass 200'
    }   
  ]
  {
    name: ->
     "Webcam"        
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
          name: "Video1"
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
        },
        {
          id: 2
          name: "Video2"
          image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png'
        }    
      ]      

    getTimelapses: (chatId) ->
      [
        {
          id: 1
          name: "Video1"
          image: 'https://pbs.twimg.com/profile_images/578237281384841216/R3ae1n61.png'
        },
        {
          id: 2
          name: "Video2"
          image: 'https://pbs.twimg.com/profile_images/598205061232103424/3j5HUXMY.png'
        }    
      ] 
  }
).factory('Panoramas', ->
  models = [
    {
      id: 1
      name: "Pan1"
      image: 'https://capxing.s3.amazonaws.com/uploads/panorama/image/16/4.jpg'
      building_name: 'Mass 200'
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