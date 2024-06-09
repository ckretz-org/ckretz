# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern
  included do
    rescue_from Exceptions::NotAuthorized, with: :not_authorized
  end

  private

  def not_authorized
    respond_to do |format|
      format.html {
        redirect_to welcome_path
      }
      format.json {
        head :unauthorized
      }
    end
  end
end
