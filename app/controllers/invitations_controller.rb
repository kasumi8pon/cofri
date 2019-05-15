# frozen_string_literal: true

class InvitationsController < ApplicationController
  skip_before_action :login_required, only: [:edit, :update]

  def create
    @invitation = current_group.invitations.create
    redirect_to @invitation
  end

  def edit
    @user = User.new
    @invitation = Invitation.find(params[:id])
    if !@invitation.authenticated?(params[:token]) || @invitation.sign_up? || @invitation.expired?
      flash[:notice] = "無効なリンクです。"
      redirect_to root_url
    end
  end

  def update
    @invitation = Invitation.find(params[:id])
    group = @invitation.user_group
    @user = group.users.create(user_params)

    if @user.save
      @invitation.update(sign_up: true)
      session[:user_id] = @user.id
      redirect_to foods_url, notice: "#{@user.name}としてユーザー登録しました"
    else
      render "edit"
    end
  end

  def show
    @invitation = Invitation.find(params[:id])
    @invitation.create_digest
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
