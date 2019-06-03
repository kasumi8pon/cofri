# frozen_string_literal: true

FactoryBot.define do
  factory :invitation do
    association :user_group
  end
end
