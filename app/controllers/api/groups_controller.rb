class API::GroupsController < API::RestfulController
  load_and_authorize_resource only: :show, find_by: :key
  load_resource only: :upload_photo, find_by: :key

  def index
    load_and_authorize :user if params[:user_id]
    instantiate_collection { |collection| (@user && collection.with_member(@user)) || collection }
    respond_with_collection
  end

  def archive
    load_resource
    GroupService.archive(group: @group, actor: current_user)
    respond_with_resource
  end

  def subgroups
    load_and_authorize :group
    @groups = @group.subgroups.select{|g| can? :show, g }
    respond_with_collection
  end

  def upload_photo
    ensure_photo_params
    service.update group: resource, actor: current_user, params: { params[:kind] => params[:file] }
    respond_with_resource
  end

  private

  def visible_records
    resource_class.visible_to(current_user)
  end

  def ensure_photo_params
    params.require(:file)
    raise ActionController::UnpermittedParameters.new([:kind]) unless ['logo', 'cover_photo'].include? params.require(:kind)
  end

end
