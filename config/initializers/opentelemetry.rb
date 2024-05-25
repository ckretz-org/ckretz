if ENV["OTEL_EXPORTER_OTLP_ENDPOINT"] && !defined?(::Rails::Console)
  require "opentelemetry/sdk"
  require "opentelemetry/instrumentation/rails"
  OpenTelemetry::SDK.configure do |c|
    c.service_name = "ckretz-app-#{Rails.env}"
    c.use_all()
  end
end
