class Public::HomesController < ApplicationController
  def top
    @recipes = Recipe.where(is_draft: false).limit(4).order("created_at DESC")
    @original_menus = OriginalMenu.joins(:recipes)
       .where(recipes: { is_draft: false }) # whereで別のテーブル呼び出すときはjoinが必ず必要になる。SQLの学習が必要。
       .select('DISTINCT original_menus.*')
       .order("recipes.created_at DESC")
       .limit(10)
    @all_ranks = Recipe.create_all_ranks
  end

  def about
  end

  def Recipe.create_all_ranks
    Recipe.find(Favorite.group(:recipe_id).order('count(recipe_id) desc').limit(3).pluck(:recipe_id))
  end
end
