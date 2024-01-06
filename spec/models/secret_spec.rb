require 'rails_helper'

RSpec.describe Secret, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user).without_validating_presence }
  end
end
