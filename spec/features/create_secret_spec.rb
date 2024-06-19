require "rails_helper"

RSpec.describe 'Create Secret', type: :system, js: true do
  include_context 'current_user'
  let!(:secret) { create(:secret, user: current_user) }

  scenario 'valid input' do
    visit secrets_path
    click_link 'New'
    assert_selector 'h2', text: 'New'
    fill_in 'secret_name', with: 'SECRET_1'
    click_button 'Delete'
    click_button 'Create Secret'
    expect(page).to have_content(secret.name)
  end
end
