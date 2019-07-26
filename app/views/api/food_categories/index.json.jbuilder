# frozen_string_literal: true

json.array! @food_categories do |food_category|
  json.partial! "api/food_categories/food_category", food_category: food_category
end
