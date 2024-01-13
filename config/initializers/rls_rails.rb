Rails.configuration.after_initialize do
  RLS.configure do |config|
    config.tenant_class = User
    #   config.tenant_fk = :tenant_id
    config.policy_dir = "db/policies"
    config.verbose = Rails.env.development?
  end
  if ENV["RLS_DISABLE"]
    RLS.disable!
  end
end
