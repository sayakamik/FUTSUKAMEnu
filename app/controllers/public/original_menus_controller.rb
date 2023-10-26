class Public::OriginalMenusController < ApplicationController
  before_action :authenticate_user!

  def index
    @keyword = search_params[:keyword]
    if @keyword.present? #代入でエラーが起きやすいため、前に記述
      @original_menus = OriginalMenu.joins(:recipes).search(@keyword)
        .where(recipes: { is_draft: false }) #whereで別のテーブル呼び出すときはjoinが必ず必要になる。SQLの学習が必要。
        .order("original_menus.created_at DESC")
        .select('DISTINCT original_menus.*')
        .page(params[:page]).per(50)
    else
      @original_menus = OriginalMenu.joins(:recipes)
        .where(recipes: { is_draft: false })
        .order("original_menus.created_at DESC")
        .select('DISTINCT original_menus.*') #重複を避ける
        .page(params[:page]).per(50)
    end
  end

  private

  def search_params
    params.permit(:keyword)
  end
end
