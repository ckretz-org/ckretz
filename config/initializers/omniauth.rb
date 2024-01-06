Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :google_oauth2, Rails.application.credentials.dig(:google_client_id), Rails.application.credentials.dig(:google_client_secret)
end

OmniAuth.config.logger = Rails.logger
