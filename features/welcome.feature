
Feature: User sign in
  As a new visitor
  I want to be able to sign up
  So I can access the application's features

Scenario: Successful Welcome Page
  Given a user exists
  Given I open the login page
  Then I should see "Welcome to CKRetz"
  Given I click "Login with Developer"
  And I fill in "Name" with "tester"
  And I fill in "Email" with "test@example.com"
  And I click "Sign In"
  Then I should be on the secrets page
  And I should see "Secrets"
