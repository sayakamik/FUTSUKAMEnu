class Public::HomesController < ApplicationController
  def top
    @recipes = Recipe.where(is_draft: false).limit(4).order("created_at DESC")
    @original_menus = OriginalMenu.joins(:recipes)
       .where(recipes: { is_draft: false })
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
