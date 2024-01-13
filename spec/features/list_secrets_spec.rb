require "rails_helper"

RSpec.describe 'List access tokens', type: :feature do
  let(:user) { create(:user) }
  let!(:access_token) { create(:access_token, user: user) }
  before :each do
    OmniAuth.config.test_mode = false
    visit welcome_path
    expect(page).to have_content("Login with Google\nLogin with Developer")
    click_button 'Login with Developer'
    fill_in 'name', with: 'Developer Name'
    fill_in 'email', with: user.email
    click_on 'Sign In'
  end
  scenario 'valid inputs' do
    expect(page).to have_content(access_token.name)
  end
end
