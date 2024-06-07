require 'rails_helper'

RSpec.describe Secret, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user).without_validating_presence }
  end

  describe 'create' do
    let!(:secret) { build(:secret) }
    before do
      allow(ApplicationController).to receive(:render)
      allow(ActiveSupport::Notifications).to receive(:instrument)
    end
    it 'sends notification upon creation' do
      secret.save!
      expect(ActiveSupport::Notifications).to have_received(:instrument).with("created.secret", { secret: secret })
    end
  end

  describe 'update' do
    let!(:secret) { create(:secret) }
    before do
      allow(ApplicationController).to receive(:render)
      allow(ActiveSupport::Notifications).to receive(:instrument)
    end
    it 'sends notification upon creation' do
      secret.touch
      expect(ActiveSupport::Notifications).to have_received(:instrument).with("updated.secret", { secret: secret })
    end
  end

end
