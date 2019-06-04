# frozen_string_literal: true

class CreateFoods < ActiveRecord::Migration[5.2]
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.integer :amount, null: false, default: 0

      t.timestamps
    end
  end
end
