# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandHandlers::Users::Create do
  let(:user) { build(:user) }

  describe "success" do
    subject(:valid_user_creation) do
      described_class.handle(command: Commands::Users::Create.new(email: user.email))
    end

    it "creates a user" do
      expect(valid_user_creation.success?).to be(true)
    end
  end

  describe "failure" do
    subject(:invalid_user_creation) do
      described_class.handle(command: Commands::Users::Create.new(email: "aa"))
    end

    it "fails to create user with bad email" do
      expect(invalid_user_creation.success?).to be(false)
    end

    it "errors on bad input" do
      expect(invalid_user_creation.errors.full_messages.first).to eql("Email is invalid")
    end
  end
end
