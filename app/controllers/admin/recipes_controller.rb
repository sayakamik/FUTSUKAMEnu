class Admin::RecipesController < ApplicationController
  def index
    @recipes = Recipe.where(is_draft: false).page(params[:page]).per(15)
    @recipes_count = @recipes.all
  end

  def show
    
  end

  def edit
  end
end
