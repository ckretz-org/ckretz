# frozen_string_literal: true

require "rails_helper"

RSpec.describe SecretsController, type: :request do
  let(:current_user) { build(:user) }
  let(:secret) { build(:secret, user: current_user) }

  before do
    allow_any_instance_of(described_class).to receive(:session).and_return({ current_user_id: current_user.id })
    allow(User).to receive(:find_by_id).with(current_user.id).and_return(current_user)


  end

  describe "index" do
    before do
      allow(current_user).to receive(:secrets).and_return([ secret ])
    end
    it do
      get secrets_path
      expect(response.status).to eql(200)
      expect(response.body).to include(secret.name)
    end
  end

end