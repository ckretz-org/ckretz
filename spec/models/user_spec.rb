# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'associations' do
    it { is_expected.to have_many(:secrets).dependent(:destroy) }
    it { is_expected.to have_many(:access_tokens).dependent(:destroy) }
  end

  describe 'validation' do
    it 'validates email format' do
      expect(described_class.new(email: "bad-email").valid?).to be(false)
    end
  end

  describe 'creation' do
    let!(:user) { build(:user) }

    before do
      allow(ActiveSupport::Notifications).to receive(:instrument).twice
      user.save!
    end

    it 'sends notification upon creation' do
      expect(ActiveSupport::Notifications).to have_received(:instrument)
                                                .with("start_transaction.active_record", { connection: anything, transaction: anything })
                                                .with("created.user", { user: user })
    end
  end

  describe 'chatbot_jwt_token' do
    let!(:user) { build(:user) }

    it 'encodes a JWT token' do
      expect(user.chatbot_jwt_token).to include("eyJhbGciOiJIUzI1NiJ9")
    end
  end
end
