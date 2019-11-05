# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "#destroy" do
    subject { @user.destroy }

    before do
      @user = user
    end

    context "ユーザーが所属しているグループに他のユーザーがいる場合" do
      let(:user) { FactoryBot.create(:user) }

      before do
        FactoryBot.create(:user, user_group: user.user_group)
      end

      it "グループは消えないこと" do
        expect { subject }.to change(UserGroup, :count).by(0)
      end
    end

    context "ユーザーが所属しているグループに他のユーザーがいない場合" do
      let(:user) { FactoryBot.create(:user) }

      it "グループも消えること" do
        expect { subject }.to change(UserGroup, :count).by(-1)
      end
    end
  end
end
