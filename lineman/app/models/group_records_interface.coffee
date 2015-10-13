angular.module('loomioApp').factory 'GroupRecordsInterface', (BaseRecordsInterface, GroupModel) ->
  class GroupRecordsInterface extends BaseRecordsInterface
    model: GroupModel

    fetchByParent: (parentGroup) ->
      @fetch
        path: "#{parentGroup.id}/subgroups"

    fetchByUser: (userKey) ->
      @fetch
        params:
          user_id: userKey
