# frozen_string_literal: true

Rails.application.configure do
  # Add session ID to lograge event payload
  config.lograge.custom_payload do |controller|
    {
      current_user_id: controller.request.session[:current_user_id],
      visitor_id: controller.request.session[:visitor_id]
    }
  end
end
