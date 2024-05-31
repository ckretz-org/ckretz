class RemoveIndexAccessTokensOnUserIdIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index nil, name: 'index_access_tokens_on_user_id'
  end
end
