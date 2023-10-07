class Public::RecipesController < ApplicationController
  def new
  end

  def index
    #1日目メニュー一覧表示
    @original_menus= OriginalMenu.all
    #レシピ一覧表示
    #クエリパラメータ(original_menu_id)をとりだす
    if @original_menu_id = params[:original_menu_id]
      #original_menu_idが同じものを全てとりだす
      @recipes = Recipe.where(original_menu_id: @original_menu_id).page(params[:page]).per(10)
    #なければ全てとりだす
    elsif recipe_name = params[:recipe_name]
      @recipes = Recipe.where("name LIKE ?","%"+ recipe_name + "%").page(params[:page]).per(10)
    else
      @recipes = Recipe.all.page(params[:page]).per(10)
    end
  end

  def show
  end

  def edit
  end

  def draft_index
  end
end
