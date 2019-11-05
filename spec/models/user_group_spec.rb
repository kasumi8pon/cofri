# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserGroup, type: :model do
  describe "#save" do
    subject { user_group.save }
    let(:user_group) { FactoryBot.build(:user_group) }

    context "新しいユーザーグループを作成した場合" do
      it "デフォルトカテゴリーも一緒に作成されること" do
        subject
        expect(user_group.food_categories.count).to eq 9
      end
    end
  end

  describe "#has_user?" do
    subject { user_group.has_user? }
    let(:user_group) { FactoryBot.create(:user_group, :with_user) }

    context "グループにユーザーが属している場合" do
      it { is_expected.to eq true }
    end

    context "グループに1人もユーザーが属していない場合" do
      before do
        user_group.users.delete_all
      end

      it { is_expected.to eq false }
    end
  end
end
