# frozen_string_literal: true

class AddUserGroupToFood < ActiveRecord::Migration[5.2]
  def change
    add_reference :foods, :user_group, foreign_key: true
  end
end
