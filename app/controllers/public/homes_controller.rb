class Public::HomesController < ApplicationController
  def top
    @recipes = Recipe.where(is_draft: false).limit(4).order("created_at DESC")
    @original_menus = OriginalMenu.joins(:recipes)
       .where(recipes: { is_draft: false }) # 公開されたレシピのみを選択
       .select('DISTINCT original_menus.*')
       .order("recipes.created_at DESC")    # レシピの作成日時で降順にソート
       .limit(10)                          # 上位10件を取得
  end

  def about
  end
end
