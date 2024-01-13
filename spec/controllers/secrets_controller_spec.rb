# frozen_string_literal: true

require "rails_helper"

RSpec.describe SecretsController, type: :request do
  let(:current_user) { build(:user) }
  let(:secret) { build(:secret, user: current_user) }
  let(:current_user_secrets) { class_double(Secret) }

  before do
    allow_any_instance_of(described_class).to receive(:session).and_return({ current_user_id: current_user.id })
    allow(User).to receive(:find_by_id).with(current_user.id).and_return(current_user)
    allow(current_user).to receive(:secrets).and_return(current_user_secrets)
    allow(current_user_secrets).to receive(:new).and_return(secret)
    allow(current_user_secrets).to receive(:find).with(secret.id).and_return(secret)
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

  describe "show" do
    it do
      get secret_path(id: secret.id)
      expect(response.status).to eql(200)
      expect(response.body).to include(secret.name)
      expect(response.body).not_to include(secret.value)
    end
  end

  describe "new" do
    it do
      get new_secret_path
      expect(response.status).to eql(200)
    end
  end

  describe "create" do
    context "valid attributes" do
      before do
        allow_any_instance_of(Secret).to receive(:save).and_return(true)
      end
      it do
        post secrets_path, params: { secret: { name: "new_secret_name", value: "value" } }
        expect(response.status).to eql(302)
      end
    end
    context "invalid attributes" do
      it do
        post secrets_path, params: {}
        expect(response.status).to eql(400)
      end
    end
    context "validation failure" do
      before do
        allow_any_instance_of(Secret).to receive(:save).and_return(false)
      end
      it do
        post secrets_path, params: { secret: { name: "new_secret_name", value: "value" } }
        expect(response.status).to eql(422)
      end
    end
  end

  describe "update" do
    context "valid attributes" do
      before do
        allow_any_instance_of(Secret).to receive(:save).and_return(true)
      end
      it do
        patch secret_path(secret), params: { secret: { name: "new_secret_name", value: "value" } }
        expect(response.status).to eql(302)
      end
    end
    context "invalid attributes" do
      it do
        patch secret_path(secret), params: {}
        expect(response.status).to eql(400)
      end
    end
    context "validation failure" do
      before do
        allow_any_instance_of(Secret).to receive(:save).and_return(false)
      end
      it do
        patch secret_path(secret), params: { secret: { name: "new_secret_name", value: "value" } }
        expect(response.status).to eql(422)
      end
    end
  end

  describe "destroy" do
    before do
      allow(secret).to receive(:destroy!)
    end
    it do
      delete secret_path(id: secret.id)
      expect(response.status).to eql(302)
    end
  end
end
