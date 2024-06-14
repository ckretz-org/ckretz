class AddAccessTokensLastUsedAt < ActiveRecord::Migration[7.1]
  def change
    add_column :access_tokens, :last_used_at, :datetime, default: nil, null: true
  end
end
