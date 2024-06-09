require 'rails_helper'

RSpec.describe SecretValue, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:secret) }
  end
end
