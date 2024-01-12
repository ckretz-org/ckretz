# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.integer :access_tokens_count, default: 0, null: false
      t.integer :secrets_count, default: 0, null: false

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
