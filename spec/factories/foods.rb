# frozen_string_literal: true

FactoryBot.define do
  factory :food do
    sequence(:name) { |n| "food#{n}" }
    amount { "enough" }
    to_buy { false }
    association :food_category
    user_group { food_category.user_group }
  end
end
