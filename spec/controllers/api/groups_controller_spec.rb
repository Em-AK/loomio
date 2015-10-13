require 'rails_helper'
describe API::GroupsController do

  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:group) { create :group, is_visible_to_public: false }
  let(:discussion) { create :discussion, group: group }

  let(:public_group) { create :group, is_visible_to_public: true }
  let(:private_group) { create :group, is_visible_to_public: false }

  before do
    group.admins << user
    sign_in user
  end

  describe 'index' do
    it 'returns groups visible to the current user' do
      public_group; private_group
      get :index
      json = JSON.parse(response.body)
      group_ids = json['groups'].map { |g| g['id'] }
      expect(group_ids).to include public_group.id
      expect(group_ids).to include group.id
      expect(group_ids).to_not include private_group.id
    end

    it 'can filter by user id' do
      public_group
      private_group.users << another_user
      group.users << another_user

      get :index, user_id: another_user.id
      json = JSON.parse(response.body)
      group_ids = json['groups'].map { |g| g['id'] }
      expect(group_ids).to include group.id
      expect(group_ids).to_not include public_group.id
      expect(group_ids).to_not include private_group.id
    end
  end

  describe 'show' do
    it 'returns the group json' do
      discussion
      get :show, id: group.key, format: :json
      json = JSON.parse(response.body)
      expect(json.keys).to include *(%w[groups])
      expect(json['groups'][0].keys).to include *(%w[
        id
        key
        name
        description
        parent_id
        created_at
        members_can_edit_comments
        members_can_raise_proposals
        members_can_vote])
    end
  end

end
