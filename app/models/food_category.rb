# frozen_string_literal: true

class FoodCategory < ApplicationRecord
  has_many :foods
  validates :name, presence: true
end
