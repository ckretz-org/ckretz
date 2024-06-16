# frozen_string_literal: true

module Queries
  module Secrets
    class Index < Queries::Query
      def resolve(**args)
        args[:query].present? ? @relation.search(args[:query]) : @relation
      end
    end
  end
end
