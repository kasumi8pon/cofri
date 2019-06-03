# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it "グループに最後のユーザーを削除したとき、グループも消える" do
    user = FactoryBot.create(:user)
    expect{ user.destroy }.to change{ UserGroup.count }.by(-1)
  end
end
