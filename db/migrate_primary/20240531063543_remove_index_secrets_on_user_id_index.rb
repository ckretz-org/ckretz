class RemoveIndexSecretsOnUserIdIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index nil, name: 'index_secrets_on_user_id'
  end
end
