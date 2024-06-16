class AddAccessTokensActive < ActiveRecord::Migration[7.1]
  def change
    add_column :access_tokens, :active, :boolean, default: true, null: false
  end
end
