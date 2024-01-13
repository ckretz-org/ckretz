require "rails_helper"

RSpec.describe 'Omniauth', type: :feature do
  scenario 'valid inputs' do
    visit welcome_path
    click_on 'Login with Developer'
    fill_in 'name', with: 'Developer Name'
    fill_in 'email', with: 'user@domain.com'
    click_on 'Sign In'
    expect(page).to have_content('Access tokens')
  end
end