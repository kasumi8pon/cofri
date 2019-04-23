# frozen_string_literal: true

class AddCategoryIdToFood < ActiveRecord::Migration[5.2]
  def change
    add_column :foods, :food_category_id, :integer
  end
end
