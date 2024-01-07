# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  context 'when condition' do
    it 'succeeds' do
      get welcome_path
      expect(response).to be_successful
      expect(response.body).to include("/auth/google_oauth2")
    end
  end
end
