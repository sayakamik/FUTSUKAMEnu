class Public::RecipesController < ApplicationController
  before_action :authenticate_user!

  def new
    @recipe = Recipe.new
    @recipe.ingredients.build # 画面で使うための空の食材オブジェクト
    @recipe.procedures.build # 画面で使うための空のレシピ手順オブジェクト
    #@recipe.build_original_menu
    @original_menus = OriginalMenu.all
    @original_menus_json = @original_menus.map{|o| { id: o.id, name: o.name } }.to_json
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    #if params[:post]で公開/非公開（下書き）の分岐を記述。[:post]はname属性の値（任意でOK）
    # 投稿ボタンを押下した場合
    if params[:post]
      #(context: :publicize)「バリデーションをある状況では実行して、ある状況では実行しない」
      if @recipe.save(context: :publicize)
        redirect_to recipe_path(@recipe), notice: "レシピを投稿しました。"
      else
        render :new, alert: "投稿に失敗しました。お手数ですが、入力内容をご確認のうえ再度お試しください"
      end
    # 下書きボタンを押下した場合
    else
      if @recipe.update(is_draft: true)
        redirect_to recipes_draft_index_path, notice: "レシピを下書き保存しました。"
      else
        render :new, alert: "投稿に失敗しました。お手数ですが、入力内容をご確認のうえ再度お試しください"
      end
    end
  end

  def index
    #1日目メニュー一覧表示
    @original_menus = OriginalMenu.joins(:recipes)
       .where(recipes: { is_draft: false }) # 公開されたレシピのみを選択
       .order("recipes.created_at DESC")    # レシピの作成日時で降順にソート
       .limit(10)                          # 上位10件を取得
    # 下書きでないレシピ一覧表示
    @recipes = Recipe.where(is_draft: false)

    #クエリパラメータ(original_menu_id)をとりだす
    if @original_menu_id = params[:original_menu_id]
      #original_menu_idが同じものを全てとりだす
      @recipes_count = @recipes.where(original_menu_id: @original_menu_id)
      @recipes = @recipes.where(original_menu_id: @original_menu_id).page(params[:page]).per(10)
    #なければ全てとりだす
    elsif recipe_name = params[:recipe_name]
      @recipes_count = @recipes.where("name LIKE ?","%"+ recipe_name + "%")
      @recipes = @recipes.where("name LIKE ?","%"+ recipe_name + "%").page(params[:page]).per(10)
    else
      @recipes_count = @recipes.all
      @recipes = @recipes.all.page(params[:page]).per(10)
    end
  end

  def show
    #1日目メニュー一覧表示
    @original_menus= OriginalMenu.all
    #レシピ詳細表示（下書き以外)
    @recipe = Recipe.where(is_draft: false).find(params[:id])
  end

  def edit
  end

  def update
    @recipe = Recipe.find(params[:id])
    # ①下書きレシピの更新（公開）の場合
    if params[:publicize_draft]
      # レシピ公開時にバリデーションを実施、下書きはバリデーション必要なく
      # updateメソッドにはcontextが使用できないため、公開処理にはattributesとsaveメソッドを使用する
      @recipe.attributes = recipe_params.merge(is_draft: false)
      #attributesメソッドは、モデルの属性にアクセスし、それらの属性を一括で設定できる
      #mergeメソッドは、2つのハッシュを結合するためのメソッド(この場合recipe_paramsとis_draft: false)
      if @recipe.save(context: :publicize)
        redirect_to recipe_path(@recipe.id), notice: "下書きのレシピを公開しました。"
      else
        @recipe.is_draft = true
        render :edit, alert: "投稿に失敗しました。お手数ですが、入力内容をご確認のうえ再度お試しください。"
      end
    # ②公開済みレシピの更新の場合
    elsif params[:update_post]
      @recipe.attributes = recipe_params
      if @recipe.save(context: :publicize)
        redirect_to recipe_path(@ecipe.id), notice: "レシピを更新しました。"
      else
        render :edit, alert: "投稿に失敗しました。お手数ですが、入力内容をご確認のうえ再度お試しください。"
      end
    # ③下書きレシピの更新（非公開）の場合
    else
      if @recipe.update(recipe_params)
        redirect_to recipe_path(@recipe.id), notice: "下書きレシピを更新しました。"
      else
        render :edit, alert: "投稿に失敗しました。お手数ですが、入力内容をご確認のうえ再度お試しください。"
      end
    end
  end

  def draft_index
    #1日目メニュー一覧表示
    @original_menus = OriginalMenu.joins(:recipes)
       .where(recipes: { is_draft: false }) # 公開されたレシピのみを選択
       .order("recipes.created_at DESC")    # レシピの作成日時で降順にソート
       .limit(10)                          # 上位10件を取得
    # 下書き(is_draft: true)レシピ一覧表示
    @recipes = current_user.recipes.where(is_draft: true)
    @recipes_count = @recipes.all
    @recipes = @recipes.all.page(params[:page]).per(10)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :is_draft, :menu_image, :original_menu_name, :original_menu_id,
      ingredients_attributes: [:id, :content, :quantity, :_destroy],
      procedures_attributes: [:id, :direction, :_destroy] ,
      original_menu_attributes: [:name]
      ) # original_menu パラメータを許可
  end

end
