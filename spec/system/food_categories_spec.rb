require'rails_helper'

RSpec.describe "FoodCategories", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    log_in_as(user)
  end
    
  it "カテゴリーを新しく登録できること" do
    click_link "カテゴリー"
    click_link "カテゴリーを追加"
    fill_in "名称", with: "お菓子"
    click_button "登録する"
    expect(page).to have_content("お菓子 を登録しました")
  end

  it "カテゴリーの情報を編集できること" do
    click_link "カテゴリー"
    first('tbody tr').click_link "編集"
    fill_in "名称", with: "お菓子"
    click_button "更新する"
    expect(page).to have_content("カテゴリーの名称を お菓子 に更新しました")
  end

  it "1つも食材が属していないカテゴリーを削除できること" do
    click_link "カテゴリー"
    accept_alert do
      first('tbody tr').click_link "削除"
    end
    expect(page).to have_content("カテゴリー なし を削除しました")
  end

  it "食材が属しているカテゴリーは削除できないこと" do
    click_link "冷蔵庫のなかみ"
    click_link "食材を追加"
    fill_in "名称", with: "レタス"
    select "なし", from: "カテゴリー"
    click_button "登録する"
    click_link "カテゴリー"
    accept_alert do
      first('tbody tr').click_link "削除"
    end
    expect(page).to have_content("カテゴリー なし には食材があるため、削除できませんでした")
  end
end