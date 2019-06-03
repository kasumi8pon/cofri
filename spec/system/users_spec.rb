require'rails_helper'

RSpec.describe "Users", type: :system do
  it "新しいユーザーとして登録できること" do
    visit new_user_path
    fill_in "名前", with: "test"
    fill_in "メールアドレス", with: "test@example.com"
    fill_in "パスワード", with: "test"
    fill_in "パスワード（確認）", with: "test"
    click_button "登録する"
    expect(page).to have_content "testとしてユーザー登録しました"
  end

  it "ユーザーを登録する際に必要な情報が足りないと、エラーメッセージが出ること" do
    visit new_user_path
    click_button "登録する"
    expect(page).to have_content "名前を入力してください"
    expect(page).to have_content "メールアドレスを入力してください"
    expect(page).to have_content "パスワードを入力してください"
  end

  it "ユーザーの情報を編集できること" do
    user = FactoryBot.create(:user)
    log_in_as(user)
    visit edit_user_path(user)
    fill_in "名前", with: "test"
    click_button "更新する"
    expect(page).to have_content "testの情報を更新しました"
  end

  it "ユーザーを削除できること" do
    user = FactoryBot.create(:user)
    log_in_as(user)
    visit edit_user_path(user)
    accept_alert do
      click_link "ユーザー削除"
    end
    expect(page).to have_content "#{user.name}を削除しました"
  end
end