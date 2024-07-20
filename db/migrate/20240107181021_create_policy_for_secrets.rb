class CreatePolicyForSecrets < ActiveRecord::Migration[7.1]
  def change
    safety_assured {
      create_policy :secrets
    }
  end
end
