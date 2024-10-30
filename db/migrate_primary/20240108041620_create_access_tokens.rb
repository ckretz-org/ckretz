class CreateAccessTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :access_tokens, id: :uuid do |t|
      t.string :name, null: false, index: true
      t.string :token, null: false, index: true, comment: 'sensitive_data=true'
      t.references :user, null: false, type: :uuid, index: true
      t.timestamps
    end
    add_index :access_tokens, [:user_id, :token]
  end
end
