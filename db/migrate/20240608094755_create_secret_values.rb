class CreateSecretValues < ActiveRecord::Migration[7.1]
  def change
    create_table :secret_values, id: :uuid do |t|
      t.string :name, null: false, index: true
      t.string :value, null: false

      t.references :secret, null: false, type: :uuid, index: true

      t.timestamps
    end
  end
end
