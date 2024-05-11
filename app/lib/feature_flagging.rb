class FeatureFlagging
  def self.client
    OpenFeature::SDK::API.instance.build_client
  end
  def self.fetch_boolean_flag(key:, default: true)
    client.fetch_boolean_value(flag_key: key, default_value: default)
  end
end
