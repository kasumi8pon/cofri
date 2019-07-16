# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ShoppingItems", type: :system do
  before do
    user = FactoryBot.create(:user)
    user_group = user.user_group
    @food = FactoryBot.create(:food, amount: "empty", user_group: user_group, to_buy: true)

    log_in_as(user)
    click_link "買い物リスト"
  end

  it "買う物に追加されている食材がリストに表示されること" do
    expect(page).to have_content @food.name
  end

  it "買う物に追加されていない食材はリストに表示されないこと" do
    click_link "冷蔵庫のなかみ"
    find(".to-buy.button").click
    click_link "買い物リスト"
    expect(page).not_to have_content @food.name
  end

  it "買ったよ！ボタンを押した食材が購入済み表示になること" do
    click_button "買った！"
    expect(page).to have_content "取り消す"
  end

  it "取り消しボタンを押した食材が未購入表示になること" do
    click_button "買った！"
    click_button "取り消す"
    expect(page).to have_content "買った！"
  end

  it "買ったよボタンを押した場合、食材の量がenoughになること" do
    click_button "買った！"
    click_link "冷蔵庫のなかみ"
    expect(page).to have_selector ".button.is-primary", text: "enough"
  end

  it "取り消しボタンを押した場合、食材の量がenoughから元の量に戻ること" do
    click_button "買った！"
    click_button "取り消す"
    click_link "冷蔵庫のなかみ"
    expect(page).to have_selector ".button.is-primary", text: "empty"
  end
end
