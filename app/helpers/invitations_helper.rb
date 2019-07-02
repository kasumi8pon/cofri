# frozen_string_literal: true

module InvitationsHelper
  def share_url(invitation)
    "https://slackbutton.herokuapp.com/post/new?url=coFriで一緒に冷蔵庫の中身を管理しましょう\n" +
    edit_invitation_url(invitation.id, token: invitation.invitation_token)
  end
end
