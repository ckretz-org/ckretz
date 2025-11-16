# Given("I am on the signup page") do
#   visit new_user_registration_path
# end
#
# When("I fill in {string} with {string}") do |field, value|
#   fill_in field, with: value
# end
#
# When("I click {string}") do |button_text|
#   click_button button_text
# end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

# Then("I should be on the root page") do
#   expect(current_path).to eq(root_path)
# end

Given(/^I open the login page$/) do
  visit welcome_path
end
