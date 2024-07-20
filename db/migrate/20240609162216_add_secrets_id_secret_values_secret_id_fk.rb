class AddSecretsIdSecretValuesSecretIdFk < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :secret_values, :secrets, column: :secret_id, primary_key: :id, on_delete: :cascade, validate: false
  end
end
