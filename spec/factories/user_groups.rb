# frozen_string_literal: true

FactoryBot.define do
  factory :user_group do
    trait :with_user do
      before(:create) do |user_group|
        user_group.users << FactoryBot.build(:user)
      end
    end
  end
end
