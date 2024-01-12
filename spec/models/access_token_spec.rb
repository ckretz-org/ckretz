require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user).without_validating_presence }
  end
  describe "create" do
    it do
      expect(described_class.create(name: "test").token).not_to be_nil
    end
  end
end
