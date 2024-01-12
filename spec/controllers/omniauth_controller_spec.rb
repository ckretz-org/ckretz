# frozen_string_literal: true

require "rails_helper"

RSpec.describe OmniauthController, type: :request do
  let(:user) { build(:user) }

  describe "google" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                           provider: "google_oauth2",
                                                                           uid: user.id,
                                                                           info: { email: user.email },
                                                                           extra: { raw_info: { sub: user.id } }
                                                                         })
    end

    it "redirects to oauth server" do
      post "/auth/google_oauth2"
      expect(response).to have_http_status(:found)
      expect(response.location).to eql("http://www.example.com/auth/google_oauth2/callback")
    end
  end

  describe "create" do
    before do
      allow(CommandHandlers::Users::Create).to receive(:handle).and_return(OpenStruct.new({ object: user }))
      get "/auth/google_oauth2/callback"
    end

    it "redirects to oauth server" do
      expect(CommandHandlers::Users::Create).to have_received(:handle)
      expect(response).to have_http_status(:found)
    end
  end
end
