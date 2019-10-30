# frozen_string_literal: true

class Api::ShoppingItemsController < ApplicationController
  def index
    @foods = current_group.foods.where(to_buy: true).eager_load(:food_category).order("food_categories.position")
  end
end
