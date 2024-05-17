class UsersController < ApplicationController
  layout "public"
  def welcome
    session[:current_user_id] = nil
  end
  def logout
    session[:current_user_id] = nil
    redirect_to welcome_path
  end
end
