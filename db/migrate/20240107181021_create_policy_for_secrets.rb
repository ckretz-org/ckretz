class CreatePolicyForSecrets < ActiveRecord::Migration[7.1]
  def change
    create_policy :secrets
  end
end
