# frozen_string_literal: true

class Api::FoodCategoriesController < ApplicationController
  def index
    @food_categories = current_group.food_categories
  end
end
