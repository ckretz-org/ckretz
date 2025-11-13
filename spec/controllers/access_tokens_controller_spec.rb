# frozen_string_literal: true

require "rails_helper"

RSpec.describe AccessTokensController, type: :request do
  let(:current_user) { build(:user) }
  let(:access_token) { build(:access_token, user: current_user) }
  let(:current_user_access_tokens) { class_double(AccessToken) }

  before do
    allow_any_instance_of(described_class).to receive(:session).and_return({ current_user_id: current_user.id })
    allow(User).to receive(:find_by_id).with(current_user.id).and_return(current_user)
    allow(current_user).to receive(:access_tokens).and_return(current_user_access_tokens)
    allow(current_user_access_tokens).to receive(:new).and_return(access_token)
    allow(current_user_access_tokens).to receive(:find).with(access_token.id).and_return(access_token)
  end

  describe "index" do
    before do
      allow(current_user).to receive(:access_tokens).and_return([ access_token ])
    end

    it do
      get access_tokens_path
      expect(response.status).to be(200)
    end

    it do
      get access_tokens_path
      expect(response.body).to include(access_token.name)
    end
  end

  describe "show" do
    it do
      get access_token_path(id: access_token.id)
      expect(response.status).to be(200)
      expect(response.body).to include(access_token.name)
    end
  end

  describe "new" do
    it do
      get new_access_token_path(format: :turbo_stream)
      expect(response.status).to be(200)
    end
  end

  describe "create" do
    context "when valid attributes" do
      before do
        allow_any_instance_of(AccessToken).to receive(:save).and_return(true)
      end

      it do
        post access_tokens_path, params: { access_token: { name: "new_token_name" } }
        expect(response.status).to be(302)
      end
    end

    context "when invalid attributes" do
      it do
        post access_tokens_path, params: {}
        expect(response.status).to be(400)
      end
    end

    context "when validation failure" do
      before do
        allow_any_instance_of(AccessToken).to receive(:save).and_return(false)
      end

      it do
        post access_tokens_path, params: { access_token: { name: "new_token_name" } }
        expect(response.status).to be(422)
      end
    end
  end

  describe "destroy" do
    before do
      allow(access_token).to receive(:destroy!)
    end

    it do
      delete access_token_path(id: access_token.id)
      expect(response.status).to be(302)
    end
  end
end
