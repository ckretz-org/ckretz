class RemoveIndexSecretValuesOnNameIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index nil, name: 'index_secret_values_on_name'
  end
end
