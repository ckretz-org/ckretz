# frozen_string_literal: true

require "rails_helper"

RSpec.describe SecretsController, type: :request do
  describe "index" do
    it do
      get "/api/app/info"
      expect(response.body).to include("{\"version\":\"")
    end
  end
end