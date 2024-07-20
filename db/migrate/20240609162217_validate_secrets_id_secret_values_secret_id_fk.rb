class ValidateSecretsIdSecretValuesSecretIdFk < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :secret_values, :secrets
  end
end
