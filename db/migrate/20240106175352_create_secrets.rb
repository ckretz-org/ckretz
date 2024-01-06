class CreateSecrets < ActiveRecord::Migration[7.1]
  def change
    create_table :secrets do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
