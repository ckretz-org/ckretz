class DropSecretsColumnValues < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :secrets, :value }
  end
end
