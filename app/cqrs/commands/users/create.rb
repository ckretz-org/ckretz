module Commands
  module Users
    class Create < Dry::Struct
      include Dry.Types()
      schema schema.strict
      attribute :email, Strict::String.constrained(format: URI::MailTo::EMAIL_REGEXP)
    end
  end
end
