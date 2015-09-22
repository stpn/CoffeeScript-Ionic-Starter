angular.module('starter.filters', []).filter 'buildingFilter', [ ->
  (models, activeBuilding) ->
    if !angular.isUndefined(models) and !angular.isUndefined(activeBuilding) and activeBuilding.length > 0

      tempClients = []
      angular.forEach models, (model) ->
        if angular.equals(model.building_name, activeBuilding)
          tempClients.push model
      tempClients
    else
      models
 ]
# angular.module('starter.filters').filter 'buildingFilter', ->
#   (models, activeBuilding) ->
#     if !activeBuilding
#       return false
#     angular.forEach models, (model) ->
#       if angular.equals(model.building_name, activeBuilding)
#         tempClients.push model
#       return
#     models
