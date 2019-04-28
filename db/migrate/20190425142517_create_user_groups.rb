# frozen_string_literal: true

class CreateUserGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :user_groups do |t|
      t.timestamps
    end
  end
end
