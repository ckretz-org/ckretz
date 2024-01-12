module CurrentUser
  extend ActiveSupport::Concern

  included do
    def current_user
      raise Exceptions::NotAuthorized unless session[:current_user_id]

      user = User.find_by_id(session[:current_user_id])
      RLS.set_tenant user
      user
    end

  end
end