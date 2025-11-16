module CurrentUser
  extend ActiveSupport::Concern

  included do
    def current_user
      @current_user ||= current_access_token_user || current_session_user
      RLS.set_tenant @current_user
      @current_user
    end

    def current_access_token_user
      return nil unless request.headers["Authorization"]

      token = request.headers["Authorization"].split(" ").last
      access_token = AccessToken.find_by_token(token)
      unless access_token
        Rails.logger.info "Access token not found: #{token}"
        raise Exceptions::NotAuthorized
      end
      access_token.user
    end

    def current_session_user
      unless session[:current_user_id]
        Rails.logger.info "No session found for current_user"
        raise Exceptions::NotAuthorized
      end

      User.find_by_id(session[:current_user_id])
    end
  end
end
