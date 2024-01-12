# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'associations' do
    it { is_expected.to have_many(:secrets).dependent(:destroy) }
    it { is_expected.to have_many(:access_tokens).dependent(:destroy) }
  end

  describe 'validation' do
    it 'validates email format' do
      expect(User.new(email: "bad-email").valid?).to be(false)
    end
  end
  describe 'creation' do
    let!(:user) { build(:user) }
    before do
      allow(ActiveSupport::Notifications).to receive(:instrument).with("created.user", { user: user })
      user.save!
    end
    it 'sends notification upon creation' do
      expect(ActiveSupport::Notifications).to have_received(:instrument)
    end
  end
end
