# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  belongs_to :user_group
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  after_destroy :user_group_destroy

  private

    def user_group_destroy
      self.user_group.destroy! unless self.user_group.has_user?
    end
end
