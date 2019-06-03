# frozen_string_literal: true

FactoryBot.define do
  factory :food_category do
    sequence(:name) { |n| "category#{n}" }
    association :user_group
  end
end
