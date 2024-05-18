class FeatureFlagging
  def self.client
    OpenFeature::SDK::API.instance.build_client
  end
  def self.fetch_boolean_flag(key:, default: true, user: nil)
    context = OpenFeature::SDK::EvaluationContext.new(email: user&.email)
    output = client.fetch_boolean_value(flag_key: key, default_value: default, evaluation_context: context)
    Rails.logger.info("Feature flag #{key} is set to #{output}")
    output
  end
end
