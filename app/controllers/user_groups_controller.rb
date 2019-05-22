# frozen_string_literal: true

class UserGroupsController < ApplicationController
  def show
    @user = current_user
    @group_members = group_members
  end
end
