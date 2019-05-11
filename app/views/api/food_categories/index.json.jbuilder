# frozen_string_literal: true

json.set! :food_categories do
  json.array! @food_categories do |food_category|
    json.id    food_category.id
    json.name  food_category.name
  end
end
