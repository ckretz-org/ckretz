class ValidateUsersIdSecretsUserIdFk < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :secrets, :users
  end
end
