class AddUsersIdAccessTokensUserIdFk < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :access_tokens, :users, column: :user_id, primary_key: :id, on_delete: :cascade, validate: false
  end
end
