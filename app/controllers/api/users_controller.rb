class API::UsersController < API::RestfulController
  load_and_authorize_resource only: :show, find_by: :key
end
