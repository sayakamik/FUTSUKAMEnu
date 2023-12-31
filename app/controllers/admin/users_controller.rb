class Admin::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes.where(is_draft: false).page(params[:page]).per(10)
    @recipes_count = @user.recipes.where(is_draft: false).count
  end

  def edit
    @user= User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
       flash[:notice] = "会員情報を変更しました。"
       redirect_to admin_user_path(@user.id)
    else
       render :edit
    end
  end

  private

  def ensure_guest_user
    @user= User.find(params[:id])
    if @user.email == 'guest@example.com'
      redirect_to admin_user_path(@user.id), alert: 'ゲストユーザの編集はできません。'
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted, :encrypted_password, :profile_image)
  end

end
