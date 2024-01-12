class UserMailer < ApplicationMailer
  default from: ENV.fetch("EMAIL_FROM", "noreply@ckretz.com")
  def register_email
    @user = params[:user]
    @web_app_url = ENV.fetch("WEB_APP_URL", "http://app.ckretz.com")
    mail(to: @user.email, subject: I18n.t("welcome"))
  end
end
