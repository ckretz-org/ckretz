# frozen_string_literal: true

require "rails_helper"

RSpec.describe SecretsController, type: :request do
  let(:current_user) { build(:user) }
  let(:secret_1) { build(:secret, user: current_user) }
  let(:current_user_secrets) { class_double(Secret) }

  before do
    allow_any_instance_of(described_class).to receive(:session).and_return({ current_user_id: current_user.id })
    allow(User).to receive(:find_by_id).with(current_user.id).and_return(current_user)
    allow(current_user).to receive(:secrets).and_return(current_user_secrets)
    allow(current_user_secrets).to receive(:find).with(secret_1.id).and_return(secret_1)
    allow(current_user_secrets).to receive(:reorder).with("created_at" => "desc").and_return(current_user_secrets)
    allow(current_user_secrets).to receive(:offset).with(0).and_return(current_user_secrets)
    allow(current_user_secrets).to receive_messages(new: secret_1, limit: [ secret_1 ])
    allow(current_user_secrets).to receive(:count).with(:all).and_return(1)
    allow(secret_1).to receive(:secret_values_hash).and_return({ a: "a", b: "b" })
  end

  describe "session authentication" do
    before do
      allow_any_instance_of(described_class).to receive(:session).and_return({})
    end

    it do
      get secrets_path
      expect(response.status).to be(302)
      expect(response.location).to include("welcome")
    end
  end

  describe "token authentication success" do
    before do
      allow_any_instance_of(described_class).to receive(:session).and_return({})
      allow(AccessToken).to receive(:find_by_token).with("TOKEN").and_return(AccessToken.build(user: current_user))
    end

    it do
      get secrets_path(format: :json), headers: { Authorization: "Bearer TOKEN" }
      expect(response.status).to be(200)
    end
  end

  describe "token authentication failure" do
    before do
      allow_any_instance_of(described_class).to receive(:session).and_return({})
      allow(AccessToken).to receive(:find_by_token).and_return(nil)
    end

    it do
      get secrets_path(format: :json)
      expect(response.status).to be(401)
    end
  end

  describe "index" do
    before do
      allow(current_user).to receive(:secrets).and_return(current_user_secrets)
    end

    it do
      get secrets_path
      expect(response.status).to be(200)
      expect(response.body).to include(secret_1.name)
    end
  end

  describe "show#HTML" do
    it do
      get secret_path(id: secret_1.id, format: :html)
      expect(response.status).to be(200)
      expect(response.body).to include(secret_1.name)
    end
  end

  describe "show#JSON" do
    it do
      get secret_path(id: secret_1.id, format: :json)
      expect(response.status).to be(200)
    end

    it do
      get secret_path(id: secret_1.id, format: :json)
      expect(JSON.parse(response.body)["values"]).to eql({ "a" => "a", "b" => "b" })
    end
  end

  describe "new" do
    it do
      get new_secret_path(format: :turbo_stream)
      expect(response.status).to be(200)
    end
  end

  describe "create" do
    context "when valid attributes" do
      before do
        allow_any_instance_of(Secret).to receive(:save).and_return(true)
      end

      it do
        post secrets_path, params: { secret: { name: "new_secret_name", value: "value" } }
        expect(response.status).to be(302)
      end
    end

    context "when invalid attributes" do
      it do
        post secrets_path, params: {}
        expect(response.status).to be(400)
      end
    end

    context "when validation failure" do
      before do
        allow_any_instance_of(Secret).to receive(:save).and_return(false)
      end

      it do
        post secrets_path, params: { secret: { name: "new_secret_name", value: "value" } }
        expect(response.status).to be(422)
      end
    end
  end

  describe "update" do
    context "when valid attributes" do
      before do
        allow_any_instance_of(Secret).to receive(:save).and_return(true)
      end

      it do
        patch secret_path(secret_1), params: { secret: { name: "new_secret_name", value: "value" } }
        expect(response.status).to be(302)
      end
    end

    context "when invalid attributes" do
      it do
        patch secret_path(secret_1), params: {}
        expect(response.status).to be(400)
      end
    end

    context "when validation failure" do
      before do
        allow_any_instance_of(Secret).to receive(:save).and_return(false)
      end

      it do
        patch secret_path(secret_1), params: { secret: { name: "new_secret_name", value: "value" } }
        expect(response.status).to be(422)
      end
    end
  end

  describe "destroy" do
    before do
      allow(secret_1).to receive(:destroy!)
    end

    it do
      delete secret_path(id: secret_1.id)
      expect(response.status).to be(302)
    end
  end
end
