class UsersController < ApplicationController
  layout "public"
  def welcome
    Rails.logger.info(trace: "Someone visited the login page", visitor_id: session[:visitor_id])
  end
  def logout
    session[:current_user_id] = nil
    redirect_to welcome_path
  end
end
