# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  context 'when condition' do
    it do
      get welcome_path
      expect(response).to be_successful
    end

    it do
      get welcome_path
      expect(response.body).to include("/auth/google_oauth2")
    end
  end
end
