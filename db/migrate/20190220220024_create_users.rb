# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false, index: true

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
