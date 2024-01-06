# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserMailer do
  let(:user) { build(:user) }
  let(:mail) { described_class.with(user: user).register_email }

  describe "register_email" do
    it "assign @email" do
      expect(mail.body.encoded).to match(user.email)
    end

    it "renders the subject" do
      expect(mail.subject).to match("welcome")
    end
  end
end
