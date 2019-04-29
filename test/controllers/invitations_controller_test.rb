# frozen_string_literal: true

require "test_helper"

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get invitations_edit_url
    assert_response :success
  end
end
