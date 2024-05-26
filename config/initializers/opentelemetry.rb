if ENV["OTEL_EXPORTER_OTLP_ENDPOINT"] && !defined?(::Rails::Console)
  require "opentelemetry/sdk"
  require "opentelemetry/instrumentation/rails"
  OpenTelemetry::SDK.configure do |c|
    c.service_name = "ckretz-app-#{Rails.env}"
    c.use "OpenTelemetry::Instrumentation::Rails"
    c.use "OpenTelemetry::Instrumentation::ActionPack"
    c.use "OpenTelemetry::Instrumentation::ActionView"
    c.use "OpenTelemetry::Instrumentation::ActiveJob"
    c.use "OpenTelemetry::Instrumentation::ActiveModelSerializers"
    c.use "OpenTelemetry::Instrumentation::ActiveRecord"
  end
end
