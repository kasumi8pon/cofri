# frozen_string_literal: true

require "rails_helper"

RSpec.describe Invitation, type: :model do
  let(:invitation) { FactoryBot.create(:invitation) }
  let(:invitation_created_at_2days_ago) { FactoryBot.create(:invitation, created_at: 2.days.ago) }

  describe "#authenticated?" do
    subject { invitation.authenticated?(token) }

    before do
      invitation.create_digest
    end

    context "正しいトークンが渡された場合" do
      let(:token) { invitation.invitation_token }

      it { is_expected.to eq true }
    end

    context "正しくないトークンが渡された場合" do
      let(:token) { invitation.invitation_token }

      it { is_expected.to eq true }
    end

    context "トークンが渡されなかった場合" do
      let(:token) { nil }

      it { is_expected.to eq false }
    end
  end

  describe "#create_digest" do
    subject { invitation.create_digest }

    it "トークンとダイジェストが生成されること" do
      subject
      expect(invitation.invitation_token).not_to eq nil
      expect(invitation.invitation_digest).not_to eq nil
    end
  end

  describe "#expired?" do
    context "24時間以内に作成されたinvitationの場合" do
      subject { invitation.expired? }

      it { is_expected.to eq false }
    end

    context "24時間以上前に作成されたinvitationの場合" do
      subject { invitation_created_at_2days_ago.expired? }

      it { is_expected.to eq true }
    end
  end
end
