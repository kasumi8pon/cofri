# frozen_string_literal: true

require "rails_helper"

RSpec.describe Invitation, type: :model do
  let(:invitation) { FactoryBot.create(:invitation) }
  let(:invitation_created_at_2days_ago) { FactoryBot.create(:invitation, created_at: 2.days.ago) }

  it "トークンが空の招待は認証されないこと" do
    expect(invitation.authenticated?(nil)).to eq false
  end

  it "2日前の招待は期限切れであること" do
    expect(invitation_created_at_2days_ago.expired?).to eq true
  end
end
