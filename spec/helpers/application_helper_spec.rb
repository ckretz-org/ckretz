# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe '#sort_link_to' do
    let(:name) { 'secrets' }
    let(:column) { 'name' }

    before do
      allow(helper).to receive_messages(request: double(params: { controller: :secrets, action: :index }), params: params)
    end

    context 'when params[:sort] is not equal to column' do
      let(:params) { { sort: 'other_column', direction: 'asc' } }

      it 'generates a link with sort set to column and direction set to asc' do
        expect(helper.sort_link_to(name, column)).to eq("<a href=\"/secrets?direction=asc&amp;sort=name\">secrets</a>")
      end
    end

    context 'when params[:sort] is equal to column and params[:direction] is asc' do
      let(:params) { { sort: 'name', direction: 'asc' } }

      it 'generates a link with sort set to column and direction set to desc' do
        expect(helper.sort_link_to(name, column)).to eq("<a href=\"/secrets?direction=desc&amp;sort=name\">secrets</a>")
      end
    end

    context 'when params[:sort] is equal to column and params[:direction] is desc' do
      let(:params) { { sort: 'name', direction: 'desc' } }

      it 'generates a link with sort set to column and direction set to asc' do
        expect(helper.sort_link_to(name, column)).to eq("<a href=\"/secrets?direction=asc&amp;sort=name\">secrets</a>")
      end
    end
  end

  describe '#turbo_id_for' do
    let(:object) { build(:secret) }

    context 'when id_or_hash is false' do
      it 'returns the object id' do
        expect(helper.turbo_id_for(object: object, id_or_hash: false)).to eq(object.hash)
      end
    end

    context 'when object is persisted' do
      before { allow(object).to receive(:persisted?).and_return(true) }

      it 'returns the object id' do
        expect(helper.turbo_id_for(object: object)).to eq("secret_#{object.id}")
      end
    end

    context 'when object is not persisted' do
      before { allow(object).to receive(:persisted?).and_return(false) }

      it 'returns the object hash' do
        expect(helper.turbo_id_for(object: object)).to eq(object.hash)
      end
    end
  end
end
