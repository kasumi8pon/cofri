# frozen_string_literal: true

class Api::FoodsController < ApplicationController
  def index
    @foods = current_group.foods.eager_load(:food_category).order("food_categories.position")
  end

  def update
    food = current_group.foods.find(params[:id])
    if food.update(food_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private
    def food_params
      params.require(:food).permit(:name, :amount, :food_category_id, :to_buy)
    end
end
