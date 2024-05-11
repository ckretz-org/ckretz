class FeatureFlagging
  def self.client
    OpenFeature::SDK::API.instance.build_client
  end
  def self.fetch_boolean_flag(key:, default: true)
    output = client.fetch_boolean_value(flag_key: key, default_value: default)
    Rails.logger.info("Feature flag #{key} is set to #{output}")
    output
  end
end
