class Public::FavoritesController < ApplicationController
  def index
    #1日目メニュー一覧表示
    @original_menus = OriginalMenu.joins(:recipes)
       .where(recipes: { is_draft: false }) # 公開されたレシピのみを選択
       .order("recipes.created_at DESC")    # レシピの作成日時で降順にソート
       .limit(10)                          # 上位10件を取得
       .uniq                              #重複削除
    # 下書きでないレシピ一覧表示
    @user = current_user
    @favorites = Favorite.where(user_id: @user.id).all
    @recipe_ids = @favorites.pluck(:recipe_id) # お気に入りレシピのIDを取得
    # レシピを取得
    @recipes = Recipe.where(id: @recipe_ids, is_draft: false).page(params[:page]).per(10)
    @recipes_count = @recipes.all
  end

  def create
    recipe = Recipe.find(params[:recipe_id])
    favorite = current_user.favorites.new(recipe_id: recipe.id)
    favorite.save
    redirect_to recipe_path(recipe)
  end

  def destroy
    recipe = Recipe.find(params[:recipe_id])
    favorite = current_user.favorites.find_by(recipe_id: recipe.id)
    favorite.destroy
    redirect_to recipe_path(recipe)
  end
end
