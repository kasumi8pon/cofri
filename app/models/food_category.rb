# frozen_string_literal: true

class FoodCategory < ApplicationRecord
  has_many :foods
  belongs_to :user_group
  acts_as_list scope: :user_group
  validates :name, presence: true
end
