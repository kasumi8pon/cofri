# frozen_string_literal: true

class UserGroup < ApplicationRecord
  has_many :users
  has_many :foods, dependent: :destroy
  has_many :food_categories, -> { order(position: :asc) }, dependent: :destroy
  has_many :invitations, dependent: :destroy
  after_create :create_default_category

  def has_user?
    !(self.users.size == 0)
  end

  private

    def create_default_category
      default_categories = %i(なし 肉類 魚介類 野菜 果物 乳製品 飲料 調味料 その他)
      default_categories.each do |name|
        self.food_categories.create(name: name)
      end
    end
end
