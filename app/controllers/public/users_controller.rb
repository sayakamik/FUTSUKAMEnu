class Public::UsersController < ApplicationController
   before_action :authenticate_user!
   before_action :ensure_normal_user, only: [:confirm_withdraw, :withdraw, :edit, :update]

  def mypage
    @user = current_user
  end

  def show
    #1日目メニュー一覧表示
    @original_menus = OriginalMenu.joins(:recipes)
       .where(recipes: { is_draft: false }) # 公開されたレシピのみを選択
       .select('DISTINCT original_menus.*')
       .order("recipes.created_at DESC")    # レシピの作成日時で降順にソート
       .limit(10)                          # 上位10件を取得
       .page(params[:page]).per(10)

    @user = User.find(params[:id])
    # 下書きでないレシピ一覧表示
    @recipes = @user.recipes.where(is_draft: false)
    @recipes_count = @recipes.count
    @recipes = @recipes.all.page(params[:page]).per(10)
    @all_ranks = Recipe.create_all_ranks
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "変更を保存しました。"
      redirect_to mypage_path
    else
      render :edit
    end
  end

  def confirm_withdraw
    @user = current_user
  end

  def withdraw
    @user = current_user
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
    #セッション情報を全て削除
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    #退会後トップ画面に遷移
    redirect_to root_path
  end

  def ensure_normal_user
    @user = current_user
    if @user.email == 'guest@example.com'
      redirect_to mypage_path, alert: 'ゲストユーザーの編集、削除はできません。'
    end
  end

  def Recipe.create_all_ranks
    Recipe.find(Favorite.group(:recipe_id).order('count(recipe_id) desc').limit(3).pluck(:recipe_id))
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted, :encrypted_password, :profile_image)
  end

end
