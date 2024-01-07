Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :google_oauth2, ENV.fetch("GOOGLE_AUTH_CLIENT_ID"), ENV.fetch("GOOGLE_AUTH_CLIENT_SECRET")
end

OmniAuth.config.logger = Rails.logger
