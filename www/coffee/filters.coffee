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
angular.module('starter.directives',[]).directive 'clickMe', ($parse) ->
  # Runs during compile
  (scope, element, attrs) ->  
#  { link: ($scope, element, iAttrs, controller) ->
    element.bind 'click', ->
      console.log '$eval type:', scope.$eval(attrs.clickMe)
      type = $parse(attrs.clickMe)(scope)
      console.log '$parse type:', type
      return
    return
angular.module('starter.directives',[]).directive 'createControl', ->
  {
    scope: createControl: '='
    link: (scope, element, attrs) ->
      element.bind 'click', ->
        console.log '$eval type:', scope.createControl
        return
  }

# angular.module('starter.directives',[]).directive 'showData', ($compile) ->
#   {
#     scope: true
#     link: (scope, element, attrs) ->
#       el = undefined
#       attrs.$observe 'template', (tpl) ->
#         if angular.isDefined(tpl)
#           # compile the provided template against the current scope
#           el = $compile(tpl)(scope)
#           # stupid way of emptying the element
#           element.html ''
#           # add the template content
#           element.append el
#         return
#       return

#   }