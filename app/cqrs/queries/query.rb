# frozen_string_literal: true

module Queries
  class Query
    class << self
      # def query_model
      #   name.sub(/::[^:]+$/, "").safe_constantize
      # end
    end

    def initialize(relation)
      @relation = relation
    end
  end
end
