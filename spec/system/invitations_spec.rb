# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Invitations", type: :system do
  before do
    @user = FactoryBot.create(:user)
    log_in_as(@user)
    click_link "ユーザー情報"
    click_link "グループ情報"
    click_link "ユーザーを招待する"
    @invitation_url = find("#invitation_url").value
  end

  it "招待URLを作成できること" do
    expect(page).to have_content "招待アドレス"
    expect(find("#invitation_url").value).not_to eq ""
  end

  it "招待URLからユーザー登録できること" do
    visit @invitation_url
    fill_in "名前", with: "test"
    fill_in "メールアドレス", with: "test@example.com"
    fill_in "パスワード", with: "test"
    fill_in "パスワード（確認）", with: "test"
    click_button "登録する"
    expect(page).to have_content "testとしてユーザー登録しました"
  end

  it "招待URLからユーザー登録に失敗した場合、エラーメッセージが出ること" do
    visit @invitation_url
    click_button "登録する"
    expect(page).to have_content "名前を入力してください"
    expect(page).to have_content "メールアドレスを入力してください"
    expect(page).to have_content "パスワードを入力してください"
  end

  it "招待URLから登録すると、招待したユーザーと同じグループに属すること" do
    visit @invitation_url
    fill_in "名前", with: "test"
    fill_in "メールアドレス", with: "test@example.com"
    fill_in "パスワード", with: "test"
    fill_in "パスワード（確認）", with: "test"
    click_button "登録する"
    click_link "ユーザー情報"
    click_link "グループ情報"
    expect(page).to have_content @user.name
  end

  it "トークンが正しくない招待URLの場合、無効であるという表示がされること" do
    visit "#{@invitation_url}123"
    expect(page).to have_content "無効なリンクです。"
  end

  it "24時間より前に作成された招待URLの場合、無効であるという表示がされること" do
    travel 2.day do
      visit @invitation_url
      expect(page).to have_content "無効なリンクです。"
    end
  end
end
