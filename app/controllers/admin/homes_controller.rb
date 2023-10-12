class Admin::HomesController < ApplicationController
  def top
    @users = User.page(params[:page]).per(25)
    @users_count = @users.all
  end
end
