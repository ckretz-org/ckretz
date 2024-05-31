# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe '#sort_link_to' do
    let(:name) { 'secrets' }
    let(:column) { 'name' }

    before do
      allow(helper).to receive(:request).and_return(double(params: { controller: :secrets, action: :index }))
      allow(helper).to receive(:params).and_return(params)
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
end
