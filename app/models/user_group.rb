# frozen_string_literal: true

class UserGroup < ApplicationRecord
  has_many :users
  has_many :foods
  has_many :food_categories
end
