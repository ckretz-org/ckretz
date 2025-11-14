# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminController, type: :controller do
  let(:admin_username) { ENV.fetch("ADMIN_USERNAME", "admin") }
  let(:admin_password) { ENV.fetch("ADMIN_PASSWORD", "password") }

  # Create a test controller that inherits from AdminController
  controller(AdminController) do
    def index
      render plain: "OK"
    end
  end

  describe "HTTP Basic Authentication" do
    context "with valid credentials" do
      it "allows access with 200 status" do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials(admin_username, admin_password)
        request.env["HTTP_AUTHORIZATION"] = credentials
        get :index

        expect(response.status).to eq(200)
      end

      it "returns OK response body" do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials(admin_username, admin_password)
        request.env["HTTP_AUTHORIZATION"] = credentials
        get :index

        expect(response.body).to eq("OK")
      end
    end

    context "with invalid username" do
      it "denies access with 401 status" do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials("wrong_user", admin_password)
        request.env["HTTP_AUTHORIZATION"] = credentials
        get :index

        expect(response.status).to eq(401)
      end

      it "includes WWW-Authenticate header" do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials("wrong_user", admin_password)
        request.env["HTTP_AUTHORIZATION"] = credentials
        get :index

        expect(response.headers["WWW-Authenticate"]).to match(/Basic/)
      end
    end

    context "with invalid password" do
      it "denies access with 401 status" do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials(admin_username, "wrong_password")
        request.env["HTTP_AUTHORIZATION"] = credentials
        get :index

        expect(response.status).to eq(401)
      end

      it "includes WWW-Authenticate header" do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials(admin_username, "wrong_password")
        request.env["HTTP_AUTHORIZATION"] = credentials
        get :index

        expect(response.headers["WWW-Authenticate"]).to match(/Basic/)
      end
    end

    context "without credentials" do
      it "prompts for authentication with 401 status" do
        get :index

        expect(response.status).to eq(401)
      end

      it "includes WWW-Authenticate header" do
        get :index

        expect(response.headers["WWW-Authenticate"]).to match(/Basic/)
      end
    end

    context "with empty credentials" do
      it "denies access" do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials("", "")
        request.env["HTTP_AUTHORIZATION"] = credentials
        get :index

        expect(response.status).to eq(401)
      end
    end
  end

  describe "inheritance" do
    it "inherits from ApplicationController" do
      expect(AdminController.superclass).to eq(ApplicationController)
    end
  end
end
