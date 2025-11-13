RSpec.shared_context 'current_user' do
  let(:current_user) { create(:user) }
  before do
    OmniAuth.config.test_mode = false
    visit welcome_path
    # expect(page).to have_content("Login with Google\nLogin with Developer")
    click_button 'Login with Developer'
    fill_in 'name', with: 'Developer Name'
    fill_in 'email', with: current_user.email
    click_on 'Sign In'
  end
end
