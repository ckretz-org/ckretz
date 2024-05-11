require "open_feature/sdk"
require "json"

OpenFeature::SDK.configure do |config|
  client = OpenFeature::FlagD::Provider.build_client do |client|
    client.host = ENV.fetch("FLAGD_HOST", "localhost")
    client.port = ENV.fetch("FLAGD_PORT", "8013")
    client.tls = ENV.fetch("FLAGD_TLS", "false") == "true"
  end
  config.set_provider(client)
end
