class CreateSecrets < ActiveRecord::Migration[7.1]
  def change
    create_table :secrets, id: :uuid do |t|
      t.string :name, null: false, index: true
      t.string :value, null: false
      t.references :user, null: false, type: :uuid, index: true
      t.timestamps
    end
    add_index :secrets, [ :user_id, :name ], unique: true
  end
end
