angular.module('loomioApp').controller 'UserPageController', ($rootScope, $routeParams, Records) ->
  $rootScope.$broadcast 'currentComponent', {page: 'userPage'}

  @init = =>
    @user = Records.users.find $routeParams.key

  @init()
  Records.groups.fetchByUser($routeParams.key)
  Records.users.findOrFetchById($routeParams.key).then @init, (error) ->
    $rootScope.$broadcast('pageError', error)

  return
