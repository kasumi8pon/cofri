# frozen_string_literal: true

class AddUserGroupToFoodCategory < ActiveRecord::Migration[5.2]
  def change
    add_reference :food_categories, :user_group, foreign_key: true
  end
end
