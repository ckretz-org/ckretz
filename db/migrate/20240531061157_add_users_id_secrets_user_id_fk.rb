class AddUsersIdSecretsUserIdFk < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :secrets, :users, column: :user_id, primary_key: :id, on_delete: :cascade
  end
end
