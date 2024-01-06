module CommandHandlers
  module Users
    class Create
      # @param [Dry::Struct] command
      # @param [String] current_user_id
      def self.handle(command:, current_user_id:)
        object = ::Accounts::User.find_or_create_by(email: command.email)
        if object.save
          OpenStruct.new(success?: true, object: object, errors: nil)
        else
          OpenStruct.new(success?: false, object: object, errors: object.errors)
        end
      end
    end
  end
end
