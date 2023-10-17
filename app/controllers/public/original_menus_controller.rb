class Public::OriginalMenusController < ApplicationController
  before_action :authenticate_user!

  def index
    @original_menus = OriginalMenu.joins(:recipes)
      .where(recipes: { is_draft: false })
      .order("original_menus.name ASC") # ここで name カラムを使って 五十音順（昇順）にソート
      .select('DISTINCT original_menus.*') #重複を避ける.uniqはここでは使えなかった。
      .page(params[:page]).per(50)
  end
end
