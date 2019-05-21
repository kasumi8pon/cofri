# frozen_string_literal: true

class UserGroupsController < ApplicationController
  def show
    @user = current_user
  end
end
