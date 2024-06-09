module CurrentUser
  extend ActiveSupport::Concern

  included do
    def current_user
      user = current_access_token_user || current_session_user
      RLS.set_tenant user
      @current_user = user
    end

    def current_access_token_user
      return nil unless request.headers["Authorization"]

      token = request.headers["Authorization"].split(" ").last
      access_token = AccessToken.find_by_token(token)
      raise Exceptions::NotAuthorized unless access_token
      access_token.user
    end

    def current_session_user
      raise Exceptions::NotAuthorized unless session[:current_user_id]

      User.find_by_id(session[:current_user_id])
    end
  end
end
