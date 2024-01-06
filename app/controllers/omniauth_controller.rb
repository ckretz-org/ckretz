class OmniauthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callback]
  def callback
    send params[:provider]
  end

  private
  def google_oauth2
    handle_auth
  end

  def developer
    handle_auth
  end

  def handle_auth
    user_info = request.env["omniauth.auth"]
    current_user = user_for(email: user_info.info.email)
    session[:current_user_id] = current_user.id
    redirect_to "/"
  end

  def user_for(email:)
    command = Commands::Users::Create.new(email: email)
    handler = CommandHandlers::Users::Create.handle(command: command, current_user_id: nil)
    handler.object
  end
end
