require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user).without_validating_presence }
  end
  describe "create" do
    it do
      expect(described_class.create(name: "test").token).not_to be_nil
    end
  end

  describe 'creation' do
    let(:user) { build(:user) }
    let!(:access_token) { build(:access_token, user: user) }
    before do
      allow(ActiveSupport::Notifications).to receive(:instrument).with("created.access_token", { access_token: access_token })
      allow(ActiveSupport::Notifications).to receive(:instrument).with("created.user", { user: user })
      access_token.save!
    end
    it 'sends notification upon creation' do
      expect(ActiveSupport::Notifications).to have_received(:instrument).twice
    end
  end
end
