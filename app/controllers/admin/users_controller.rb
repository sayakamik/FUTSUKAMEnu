class Admin::UsersController < ApplicationController
  def show
     @customer= Customer.find(params[:id])
  end

  def edit
  end
end
