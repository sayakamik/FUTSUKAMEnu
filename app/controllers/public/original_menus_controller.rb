class Public::OriginalMenusController < ApplicationController
  def index
    @original_menus = OriginalMenu.joins(:recipes)
      .where(recipes: { is_draft: false })
      .select('DISTINCT original_menus.*') #重複を避ける.uniqはここでは使えなかった。
      .order("original_menus.name ASC") # ここで name カラムを使って 五十音順（昇順）にソート
      .page(params[:page]).per(50)

  end
end
