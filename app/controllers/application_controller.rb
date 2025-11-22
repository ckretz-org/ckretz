class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  include ExceptionHandler
  include WithProsopite
  after_action do
    session[:visitor_id] ||= SecureRandom.uuid
  end
end
