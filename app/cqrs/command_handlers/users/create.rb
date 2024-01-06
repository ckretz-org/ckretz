module CommandHandlers
  module Users
    class Create
      def self.handle(command:)
        object = User.find_or_create_by(email: command.email)
        if object.save
          OpenStruct.new(success?: true, object: object, errors: nil)
        else
          OpenStruct.new(success?: false, object: object, errors: object.errors)
        end
      end
    end
  end
end
