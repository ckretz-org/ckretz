class OmniauthController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: [ :index ]
  def callback
    provider_name = params[:provider].to_sym
    provider_callback = available_providers[provider_name]
    send provider_callback
  end

  def failure
    redirect_to welcome_path, alert: params["message"]
  end

  private
  def available_providers
    { google_oauth2: :google_oauth2, developer: :developer }
  end

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
    redirect_to secrets_path
  end

  def user_for(email:)
    command = Commands::Users::Create.new(email: email)
    handler = CommandHandlers::Users::Create.handle(command: command)
    handler.object
  end
end
