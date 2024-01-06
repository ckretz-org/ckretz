module Commands
  module Users
    class Create < Dry::Struct
      include Dry.Types()
      schema schema.strict
      attribute :email, Strict::String
    end
  end
end
