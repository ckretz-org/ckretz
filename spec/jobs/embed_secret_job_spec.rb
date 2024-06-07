require 'rails_helper'

RSpec.describe EmbedSecretJob, type: :job do
  let(:secret) { create(:secret) }
  let(:response_body) { { "embedding" => "some_embedding" }.to_json }

  before do
    allow(Net::HTTP).to receive(:post).and_return(OpenStruct.new(code: "200", body: response_body))
    allow(Secret).to receive(:find).and_return(secret)
    allow(secret).to receive(:update)
  end

  it 'performs the job correctly' do
    described_class.perform_now(id: secret.id)

    expect(Secret).to have_received(:find).with(secret.id)
    expect(Net::HTTP).to have_received(:post)
    expect(secret).to have_received(:update).with(embedding: "some_embedding")
  end

  context 'when the response code is not 200' do
    before do
      allow(Net::HTTP).to receive(:post).and_return(OpenStruct.new(code: "500", body: response_body))
    end

    it 'raises an error' do
      expect { described_class.perform_now(id: secret.id) }.to raise_error(RuntimeError, /Failed to embed secret/)
    end
  end
end
