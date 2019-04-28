# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  belongs_to :user_group
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
