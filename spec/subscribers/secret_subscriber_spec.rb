# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SecretSubscriber do
  let!(:secret) { build(:secret) }
  before do
    allow(EmbedSecretJob).to receive(:perform_later).with({ id: secret.id }).and_return(true)
  end
  describe 'created' do
    subject(:create_event) do
      described_class.new.created(OpenStruct.new(payload: { secret: secret }))
    end
    it 'succeeds' do
      create_event
      expect(EmbedSecretJob).to have_received(:perform_later).with(id: secret.id)
    end
  end
  describe 'updated' do
    subject(:update_event) do
      described_class.new.updated(OpenStruct.new(payload: { secret: secret }))
    end
    it 'succeeds' do
      update_event
      expect(EmbedSecretJob).to have_received(:perform_later).with(id: secret.id)
    end
  end
end
