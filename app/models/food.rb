# frozen_string_literal: true

class Food < ApplicationRecord
  validates :name, presence: true
  validates :name, presence: true

  enum amount: {
    empty: 0,
    short: 1,
    enough: 2
          }
end
