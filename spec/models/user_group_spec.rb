# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserGroup, type: :model do
  let(:user_group) { FactoryBot.create(:user_group) }

  it "一人もユーザーがいないグループは、 has_user? が false を返すこと" do
    expect(user_group.has_user?).to eq false
  end
  
  it "新しいグループがつくられたとき、デフォルトカテゴリーも一緒に作成されること" do
    expect(user_group.food_categories.count).to eq 9
  end

  it "グループを削除したとき、カテゴリーも削除されること" do
    expect{ user_group.destroy }.to change{ user_group.food_categories.count }.by(-9)
  end
end
