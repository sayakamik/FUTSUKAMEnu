class Admin::HomesController < ApplicationController
  def top
    @users = User.page(params[:page])
  end
end
