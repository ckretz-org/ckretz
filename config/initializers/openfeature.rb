require "open_feature/sdk"
require "json"
require "grpc"
class OpenFeature::FlagD::Provider::Client
  def process_request(default_value, &block)
    Rails.logger.info("process_request")
    response = block.call
    OpenFeature::SDK::Provider::ResolutionDetails.new(
      value: response.value,
      reason: response.reason,
      variant: response.variant,
      error_code: nil,
      error_message: nil,
      flag_metadata: nil
    )
  rescue GRPC::NotFound => e
    Rails.logger.error("FLAG_NOT_FOUND")
    Rails.logger.error(e)
    error_response(default_value, "FLAG_NOT_FOUND", e.message)
  rescue GRPC::InvalidArgument => e
    Rails.logger.error("TYPE_MISMATCH")
    Rails.logger.error(e)
    error_response(default_value, "TYPE_MISMATCH", e.message)
  rescue GRPC::Unavailable => e
    Rails.logger.error("FLAG_NOT_FOUND")
    Rails.logger.error(e)
    error_response(default_value, "FLAG_NOT_FOUND", e.message)
  rescue GRPC::DataLoss => e
    Rails.logger.error("PARSE_ERROR")
    Rails.logger.error(e)
    error_response(default_value, "PARSE_ERROR", e.message)
  rescue => e
    Rails.logger.error("GENERAL")
    Rails.logger.error(e)
    error_response(default_value, "GENERAL", e.message)
  end
end

OpenFeature::SDK.configure do |config|
  client = OpenFeature::FlagD::Provider.build_client do |client|
    client.host = ENV.fetch("FLAGD_HOST", "localhost")
    client.port = ENV.fetch("FLAGD_PORT", "8013")
    client.tls = ENV.fetch("FLAGD_TLS", "false") == "true"
  end
  config.set_provider(client)
end
