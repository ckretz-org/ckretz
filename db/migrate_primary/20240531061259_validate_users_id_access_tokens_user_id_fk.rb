class ValidateUsersIdAccessTokensUserIdFk < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :access_tokens, :users
  end
end
