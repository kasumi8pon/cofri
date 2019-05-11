# frozen_string_literal: true

class AddPositionToFoodCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :food_categories, :position, :integer
  end
end
