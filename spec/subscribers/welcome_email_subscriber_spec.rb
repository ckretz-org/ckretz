# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeEmailSubscriber do
  describe 'created' do
    subject(:receive_event) do
      described_class.new.created(OpenStruct.new(payload: { user: user }))
    end

    let!(:user) { build(:user) }


    before do
      allow(UserMailer).to receive(:with).with({ user: user }).and_return(OpenStruct.new(register_email: OpenStruct.new(deliver_later: nil)))
    end

    it 'sends email' do
      receive_event
      expect(UserMailer).to have_received(:with)
    end
  end
end
