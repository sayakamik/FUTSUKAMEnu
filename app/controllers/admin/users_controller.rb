class Admin::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes.where(is_draft: false).page(params[:page]).per(10)
    @recipes_count = @recipes.all
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

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted, :encrypted_password, :profile_image)
  end

end
