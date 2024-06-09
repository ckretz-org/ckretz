# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SecretValuesController, type: :request do
  let(:user) { build(:user) }
  let(:secret_value) { create(:secret_value, secret: create(:secret, user: user)) }

  before do
    allow_any_instance_of(described_class).to receive(:current_user).and_return(user)
  end

  describe '#new#Turbo' do
    it do
      get new_secret_value_path(format: :turbo_stream)
      expect(response.status).to eq(200)
      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      expect(response.body).to include('target="secret_values"')
    end
  end

  describe '#destroy' do
    it 'destroys NON existing secret_value' do
      delete secret_value_path("12345", format: :turbo_stream)
      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      expect(response.body).to include('<turbo-stream action="remove" target="12345"></turbo-stream>')
    end
    it 'destroys the existing secret_value' do
      secret_value
      expect {
        delete secret_value_path(secret_value)
      }.to change(SecretValue, :count).by(-1)
    end

    it 'renders a turbo_stream response to remove the secret_value' do
      secret_value
      delete secret_value_path(secret_value, format: :turbo_stream)
      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
    end
  end
end
