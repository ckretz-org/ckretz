unless Rails.env.production?
  require "prosopite/middleware/rack"
  Rails.configuration.middleware.use(Prosopite::Middleware::Rack)
  # Prosopite.allow_stack_paths = ['substring_in_call_stack', /regex/]
  Prosopite.ignore_queries = [/current_setting/]
end

