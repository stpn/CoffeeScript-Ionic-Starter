angular.module('starter.services', []).factory('Buildings', ->
  models = [
    {
      id: 1
      name: "Massachusetts 200"
      code: "M200"
    },
    {
      id: 2
      name: "Massachusetts 250"
      code: "M250"
    },
    {
      id: 3
      name: "Massachusetts 600"
      code: "M600"
    },
    {
      id: 4
      name: "Massachusetts 201"
      code: "M201"
    },
    {
      id: 5
      name: "Fassachusetts 200"
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
  tabName = "SELECT BUILDING"

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
      image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
      building_name: 'Massachusetts 200'
      project_name: "Massachusetts 200"
    },
    {
      id: 2
      name: "Sustainability Presentation"
      image: 'https://capxing.s3.amazonaws.com/uploads/view/image/2/thumb_250Mass_view1.jpg'
      building_name: 'Massachusetts 250'
      project_name: "Massachusetts 250"      
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
          image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
        },
        {
          id: 2
          image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
        },
        {
          id: 3
          image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
        },
        {
          id: 4
          image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
        },
        {
          id: 5
          image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
        }  
      ]

  }
).factory('Renderings', ->
  models = [
    {
      id: 1
      name: "Rend1"
      image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
      building_name: 'Massachusetts 200'
    },
    {
      id: 2
      name: "Rend2"
      image: 'https://capxing.s3.amazonaws.com/uploads/view/image/2/thumb_250Mass_view1.jpg'
      building_name: 'Massachusetts 300'
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
      image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
      building_name: 'Massachusetts 200'
    },
    {
      id: 2
      name: "View2"
      image: 'https://capxing.s3.amazonaws.com/uploads/view/image/2/thumb_250Mass_view1.jpg'
      building_name: 'Massachusetts 200'
    },   
   {
      id: 1
      name: "View1"
      image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
      building_name: 'Massachusetts 200'
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
      image: 'https://capxing.s3.amazonaws.com/uploads/floorplan/image/4/200M_FP_PH_2.svg'
      building_name: 'Massachusetts 200'
    },
    {
      id: 2
      name: "Floorplan2"
      image: 'https://capxing.s3.amazonaws.com/uploads/floorplan/image/4/200M_FP_PH_2.svg'
      building_name: 'Massachusetts 200'
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
      image: 'https://capxing.s3.amazonaws.com/uploads/rendering/image/5/thumb_200Mass_rendering1.jpg'
      building_name: 'Massachusetts 200'
      recording: 'http://www.w3schools.com/html/mov_bbb.mp4 '
    },
    {
      id: 2
      name: "Video2"
      image: 'https://capxing.s3.amazonaws.com/uploads/view/image/2/thumb_250Mass_view1.jpg'
      building_name: 'Massachusetts 200'
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
      image: 'https://oxblue.com/archive/517405af56b6a32dcbb7fb3b7373378e/2048x1536.jpg?1442798939'
      building_name: 'Massachusetts 200'
    },
    {
      id: 2
      name: "Webcam2"
      image: 'https://oxblue.com/archive/276b2472bc731684941f635b7d1c2009/2048x1536.jpg?1442798939'
      building_name: 'Massachusetts 200'
    },
    {
      id: 3
      name: "Webcam3"
      image: 'https://oxblue.com/archive/52785a2e10cf0eb8a0b097e04e35aeb5/2048x1536.jpg?1442798939'
      building_name: 'Massachusetts 200'
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
          image: 'https://capxing.s3.amazonaws.com/uploads/panorama/image/15/4.jpg'
        },
        {
          id: 2
          name: "Video2"
          image: 'https://capxing.s3.amazonaws.com/uploads/panorama/image/16/4.jpg'
        }    
      ]      

    getTimelapses: (chatId) ->
      [
        {
          id: 1
          name: "Video1"
          image: 'https://oxblue.com/archive/2a415640359473ad01cd8b83498f8eea/2048x1536.jpg?1442798939'
        },
        {
          id: 2
          name: "Video2"
          image: 'https://oxblue.com/archive/2a415640359473ad01cd8b83498f8eea/2048x1536.jpg?1442798939'
        }    
      ] 
  }
).factory('Panoramas', ->
  models = [
    {
      id: 1
      name: "Pan1"
      image: 'https://capxing.s3.amazonaws.com/uploads/panorama/image/16/4.jpg'
      building_name: 'Massachusetts 200'
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