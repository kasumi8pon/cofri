FactoryBot.define do
  factory :user do
    name { "test user" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "testuser-password" }
    association :user_group
  end
end
