# frozen_string_literal: true

class Food < ApplicationRecord
  belongs_to :food_category
  belongs_to :user_group
  validates :name, presence: true
  validates :amount, presence: true
  after_update :check_to_buy

  enum amount: {
    empty: 0,
    short: 1,
    enough: 2
          }
  
  private

    def check_to_buy
      self.update_columns(to_buy: false) if self.amount == "enough"
    end
end
