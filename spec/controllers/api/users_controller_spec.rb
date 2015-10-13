require 'rails_helper'
describe API::UsersController do

  let(:user) { create :user }
  let(:another_user) { create :user }

  before { sign_in user }

  describe 'show' do
    it 'returns the user json' do
      get :show, id: another_user.key, format: :json
      json = JSON.parse(response.body)
      expect(json.keys).to include *(%w[users])
      expect(json['users'][0].keys).to include *(%w[
        id
        name
        username
        avatar_initials
        avatar_kind
        avatar_url
        profile_url
        time_zone
        search_fragment
        label])
      expect(json['users'][0].keys).to_not include 'email'
      expect(json['users'][0]['name']).to eq another_user.name
    end

    it 'does not return a deactivated user' do
      another_user.update deactivated_at: 1.day.ago
      get :show, id: another_user.key, format: :json
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['exception']).to eq 'CanCan::AccessDenied'
    end
  end

end
