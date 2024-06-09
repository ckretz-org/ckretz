class AddSecretsIdSecretValuesSecretIdFk < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :secret_values, :secrets, column: :secret_id, primary_key: :id
  end
end
