class AddSecretValuesNameSecretIdIndex < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_index :secret_values, %w[name secret_id], name: :index_secret_values_name_secret_id, unique: true, algorithm: :concurrently
  end
end
