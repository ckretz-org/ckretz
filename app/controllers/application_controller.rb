class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  rescue_from Exceptions::NotAuthorized, with: :not_authorized

  private
  def not_authorized
    redirect_to welcome_path
  end
end
