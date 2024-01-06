module Commands
  module Attributes
    class OptionalId < Dry::Struct
      include Dry.Types()
      attribute? :id, String.optional.constrained(format: Uuid.regex).default { SecureRandom.uuid }
    end
  end
end
