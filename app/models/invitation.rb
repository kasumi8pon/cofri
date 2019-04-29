# frozen_string_literal: true

class Invitation < ApplicationRecord
  attr_accessor :invitation_token
  belongs_to :user_group

  def Invitation.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Invitation.new_token
    SecureRandom.urlsafe_base64
  end

  def create_digest
    self.invitation_token = Invitation.new_token
    update_attribute(:invitation_digest, Invitation.digest(invitation_token))
  end

  def authenticated?(invitation_token)
    return false if invitation_digest.nil?
    BCrypt::Password.new(invitation_digest).is_password?(invitation_token)
  end

  def expired?
    self.created_at < 24.hours.ago
  end
end
