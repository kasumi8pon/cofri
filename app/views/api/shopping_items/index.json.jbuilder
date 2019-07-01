# frozen_string_literal: true

json.array! @foods do |food|
  json.id             food.id
  json.name           food.name
  json.amount         food.amount_before_type_cast
  json.food_category  food.food_category
  json.to_buy         food.to_buy
end
