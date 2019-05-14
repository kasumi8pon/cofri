# frozen_string_literal: true

class UserGroup < ApplicationRecord
  has_many :users
  has_many :foods, dependent: :destroy
  has_many :food_categories, -> { order(position: :asc) }, dependent: :destroy
  has_many :invitations, dependent: :destroy

  def has_user?
    !(self.users.size == 0)
  end
end
