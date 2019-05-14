# frozen_string_literal: true

class FoodCategory < ApplicationRecord
  has_many :foods, dependent: :restrict_with_error
  belongs_to :user_group
  acts_as_list scope: :user_group
  validates :name, presence: true
end
