# frozen_string_literal: true

class FoodCategories::PositionController < ApplicationController
  def update
    @food_category = current_group.food_categories.find(params[:food_category_id])

    case params[:move]
    when "higher"
      @food_category.move_higher
    when "lower"
      @food_category.move_lower
    when "top"
      @food_category.move_to_top
    when "bottom"
      @food_category.move_to_bottom
    end

    redirect_back fallback_location: root_path
  end
end
