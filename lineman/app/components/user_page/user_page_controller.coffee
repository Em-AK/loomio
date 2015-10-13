angular.module('loomioApp').controller 'UserPageController', ($rootScope, $routeParams, Records, LoadingService) ->
  $rootScope.$broadcast 'currentComponent', {page: 'userPage'}

  @init = =>
    @user = Records.users.find $routeParams.key

  @loadGroups = ->
    Records.memberships.fetchByUser($routeParams.key)
  LoadingService.applyLoadingFunction @, 'loadGroups'

  @init()
  @loadGroups()

  Records.users.findOrFetchById($routeParams.key).then @init, (error) ->
    $rootScope.$broadcast('pageError', error)

  return
