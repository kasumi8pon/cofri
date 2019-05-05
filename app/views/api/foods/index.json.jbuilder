# frozen_string_literal: true

json.set! :foods do
  json.array! @foods do |food|
    json.id        food.id
    json.name      food.name
    json.amount    food.amount_before_type_cast
    json.category  food.food_category.name
  end
end
