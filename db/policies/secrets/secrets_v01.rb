RLS.policies_for :secrets do
  policy :secrets_policy do
    using <<-SQL
      user_id = current_tenant_id()
    SQL
  end
end
