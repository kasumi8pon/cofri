# frozen_string_literal: true

class Food < ApplicationRecord
  belongs_to :food_category
  belongs_to :user_group
  validates :name, presence: true
  validates :amount, presence: true

  enum amount: {
    empty: 0,
    short: 1,
    enough: 2
          }
end
