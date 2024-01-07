class CreateSecrets < ActiveRecord::Migration[7.1]
  def change
    create_table :secrets, id: :uuid do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.references :user, null: false, type: :uuid
      t.timestamps
    end
  end
end
