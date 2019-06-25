# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Foods", type: :system do
  before do
    user = FactoryBot.create(:user)
    user_group = user.user_group
    category1 = FactoryBot.create(:food_category, user_group: user_group)
    category2 = FactoryBot.create(:food_category, user_group: user_group)
    @enough_food = FactoryBot.create(:food, amount: "enough", user_group: user_group, food_category: category1)
    @empty_food = FactoryBot.create(:food, amount: "empty", user_group: user_group, food_category: category1, to_buy: true)
    @other_category_food = FactoryBot.create(:food, user_group: user_group, food_category: category2, amount: "short")

    log_in_as(user)
    click_link "冷蔵庫のなかみ"
  end

  it "食材が一覧で表示されること" do
    expect(page).to have_content(@enough_food.name)
    expect(page).to have_content(@empty_food.name)
  end

  it "新しい食材を登録できること" do
    click_link "食材を追加"
    fill_in "名称", with: "レタス"
    select "野菜", from: "カテゴリー"
    click_button "登録する"
    expect(page).to have_content("レタスを冷蔵庫に登録しました")
  end

  it "食材の情報を編集できること" do
    click_link "編集", match: :first
    fill_in "名称", with: "レタス"
    select "野菜", from: "カテゴリー"
    click_button "更新する"
    expect(page).to have_content("レタスの情報を更新しました")
  end

  it "食材を削除できること" do
    accept_alert do
      click_link "削除", match: :first
    end
    expect(page).to have_content("#{@enough_food.name}を冷蔵庫から削除しました")
  end

  it "食材一覧から食材の量を変更できること" do
    click_button "short", match: :first
    expect(page).to have_selector "button.is-primary", text: "short"
  end

  it "残量がある食材のみ表示できること" do
    check "残量があるもののみ"
    expect(page).to have_content @enough_food.name
    expect(page).not_to have_content @empty_food.name
  end

  it "買うものチェックがついている食材のみ表示ができること" do
    check "買うもののみ"
    expect(page).to have_content @empty_food.name
    expect(page).not_to have_content @enough_food.name
  end

  it "食材のカテゴリーでフィルターできること" do
    select @other_category_food.food_category.name, from: "category"
    expect(page).not_to have_content @enough_food.name
    expect(page).not_to have_content @empty_food.name
    expect(page).to have_content @other_category_food.name
  end

  it "食材の名称で検索できること" do
    fill_in "検索", with: @enough_food.name
    expect(page).to have_content @enough_food.name
    expect(page).not_to have_content @empty_food.name
  end
end
