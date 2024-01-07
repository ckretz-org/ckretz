Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :google_oauth2, ENV.fetch("GOOGLE_AUTH_CLIENT_ID", "SETUP_ME_UP_PLZ"), ENV.fetch("GOOGLE_AUTH_CLIENT_SECRET", "SETUP_ME_UP_PLZ")
end

OmniAuth.config.logger = Rails.logger
