require'rails_helper'

RSpec.describe "UserGroups", type: :system do
  it "自分と同じグループに属するユーザーがいる場合、グループ情報に表示されること" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user, user_group: user1.user_group)
    log_in_as(user1)
    visit user_group_path(user1.user_group)
    expect(page).to have_content(user2.name)
  end

  it "自分と同じグループに属するユーザーがいない場合、グループ情報に表示されること" do
    user = FactoryBot.create(:user)
    log_in_as(user)
    visit user_group_path(user.user_group)
    expect(page).to have_content("あなたは他のユーザーとcoFriの情報を共有していません")
  end
end