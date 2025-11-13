require "rails_helper"

RSpec.describe 'Omniauth', type: :feature do
  let(:user) { create(:user) }

  scenario 'valid inputs' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    OmniAuth.config.test_mode = false
    visit welcome_path
    expect(page).to have_content("Login with Google\nLogin with Developer")
    click_on 'Login with Developer'
    expect(page).to have_current_path("/auth/developer")
    fill_in 'name', with: 'Developer Name'
    fill_in 'email', with: user.email
    click_on 'Sign In'
    expect(page).to have_content("Secrets")
    visit logout_path
    expect(page).to have_content("Login with Google\nLogin with Developer")
  end
end
