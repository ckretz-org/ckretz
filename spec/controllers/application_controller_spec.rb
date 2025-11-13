# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :request do
  describe "rescue_from" do
    before do
      allow_any_instance_of(AccessTokensController).to receive(:current_user).and_raise(Exceptions::NotAuthorized)
    end

    it do
      get access_tokens_path
      expect(response.location).to eql("http://www.example.com/welcome")
    end
  end
end
