# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]
  def new
    @user = User.new
  end

  def create
    group = UserGroup.create
    @user = group.users.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to foods_url, notice: "#{@user.name}としてユーザー登録しました"
    else
      render "new"
    end
  end

  def edit
    @group_members = group_members
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to foods_url, notice: "#{@user.name}の情報を更新しました"
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_url, notice: "#{@user.name}を削除しました"
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user == @user
    end
end
