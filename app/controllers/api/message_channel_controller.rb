class API::MessageChannelController < API::RestfulController

  rescue_from(MessageChannelService::AccessDeniedError)   { |e| respond_with_standard_error e, 400 }
  rescue_from(MessageChannelService::UnknownChannelError) { |e| respond_with_standard_error e, 400 }

  def subscribe
    @subscriptions = [MessageChannelService.subscribe_to(user: current_user, channel: params[:channel])]
    respond_with_subscriptions
  end

  def subscribe_user
    @subscriptions = current_user.groups.map { |group| MessageChannelService.subscribe_to(user: current_user, model: group) }
    @subscriptions <<                                  MessageChannelService.subscribe_to_notifications_for(current_user)
    respond_with_subscriptions
  end

  private

  def respond_with_subscriptions
    render json: @subscriptions, root: false
  end

end
