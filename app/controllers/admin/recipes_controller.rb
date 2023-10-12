class Admin::RecipesController < ApplicationController
  def index
    @recipes = Recipe.where(is_draft: false).page(params[:page]).per(15)
    @recipes_count = @recipes.all
  end

  def show
    @recipe = Recipe.where(is_draft: false).find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
  end
end
