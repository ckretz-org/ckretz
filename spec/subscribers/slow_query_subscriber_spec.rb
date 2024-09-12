# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlowQuerySubscriber do
  before do
    SlowQuerySubscriber
    allow(Rails.logger).to receive(:warn).once.with(/slow_query/)
  end
  context 'when condition' do
    it 'succeeds' do
      ActiveRecord::Base.connection.execute("select PG_SLEEP(0.2)")
    end
  end
end
