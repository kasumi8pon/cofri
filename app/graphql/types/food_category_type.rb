module Types
  class FoodCategoryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :user_group_id, Integer, null: true
    field :position, Integer, null: true
  end
end
