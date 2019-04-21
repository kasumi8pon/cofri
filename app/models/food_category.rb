# frozen_string_literal: true

class FoodCategory < ApplicationRecord
  validates :name, presence: true
end
