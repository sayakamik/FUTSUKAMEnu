class Public::UsersController < ApplicationController
   before_action :authenticate_user!

  def mypage
    @user = current_user
  end

  def show
    #1日目メニュー一覧表示
    @original_menus = OriginalMenu.joins(:recipes)
       .where(recipes: { is_draft: false }) # 公開されたレシピのみを選択
       .order("recipes.created_at DESC")    # レシピの作成日時で降順にソート
       .limit(10)                          # 上位10件を取得

    @user = User.find(params[:id])
    # 下書きでないレシピ一覧表示
    @recipes = @user.recipes.where(is_draft: false)
    @recipes_count = @recipes.all
    @recipes = @recipes.all.page(params[:page]).per(10)
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

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted, :encrypted_password, :profile_image)
  end

end
