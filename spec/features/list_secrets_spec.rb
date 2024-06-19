require "rails_helper"

RSpec.describe 'List secrets', type: :feature do
  include_context 'current_user'
  let!(:secret) { create(:secret, user: current_user) }
  scenario 'valid inputs' do
    visit secrets_path
    expect(page).to have_content(secret.name)
  end
end
