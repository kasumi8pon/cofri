# frozen_string_literal: true

class AddUserGroupToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :user_group, foreign_key: true
  end
end
