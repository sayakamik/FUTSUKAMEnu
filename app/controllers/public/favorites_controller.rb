class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  # before_action :ensure_normal_user, only: [:create]
  before_action :set_recipe, only: [:create, :destroy]
  #検証ツール編集し複数回お気に入り登録を防ぐため
  before_action :check_favorite, only: [:create]

  def index
    #1日目メニュー一覧表示
    @original_menus = OriginalMenu.joins(:recipes)
       .where(recipes: { is_draft: false })
       .select('DISTINCT original_menus.*') #重複削除
       .order("recipes.created_at DESC")
       .limit(10)

    # 下書きでないレシピ一覧表示
    @user = current_user
    @favorites = Favorite.where(user_id: @user.id).all
    @recipe_ids = @favorites.pluck(:recipe_id) # お気に入りレシピのIDを取得
    # レシピを取得
    @recipes = Recipe.where(id: @recipe_ids, is_draft: false).page(params[:page]).per(10)
    @recipes_count = Recipe.where(id: @recipe_ids, is_draft: false).count
  end

  def create
    favorite = @recipe.favorites.new(user_id: current_user.id)
    favorite.save
    # app/views/public/favorites/create.js.erbを参照する
  end

  def destroy
    favorite = @recipe.favorites.find_by(user_id: current_user.id)
    favorite.destroy
    # app/views/public/favorites/destroy.js.erbを参照する
  end

  private
  # def ensure_normal_user
  #   @user = current_user
  #   if @user.email == 'guest@example.com'
  #     redirect_to root_path, alert: 'ゲストユーザーのお気に入り登録はできません。'
  #   end
  # end

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def check_favorite
    if current_user.favorites.exists?(recipe_id: @recipe.id)
      flash[:notice] = "すでにお気に入り登録済みです"
      redirect_to recipe_path(@recipe)
    end
  end

end
