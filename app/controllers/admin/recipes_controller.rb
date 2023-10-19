class Admin::RecipesController < ApplicationController

  def index
    @recipes = Recipe.where(is_draft: false)
               .page(params[:page]).per(10)
               .order("recipes.created_at DESC")
    @recipes_count = @recipes.all
  end

  def show
    @recipe = Recipe.where(is_draft: false).find(params[:id])
    @post_comment = PostComment.new
    @tag_list = @recipe.tags.pluck(:tag_name).join(',')
    @recipe_tag_relations = @recipe.tags
  end

  def edit
    @recipe = Recipe.where(is_draft: false).find(params[:id])
    @original_menus = OriginalMenu.all
    @original_menus_json = @original_menus.map{|o| { id: o.id, name: o.name } }.to_json
    @tag_list = @recipe.tags.pluck(:tag_name).join(',')
  end

  def update
    @recipe = Recipe.where(is_draft: false).find(params[:id])
    tag_list = params[:recipe][:tag_name].split(',')
     if params[:update_post]
      @recipe.attributes = recipe_params
        if @recipe.save(context: :publicize)
          @recipe.save_tags(tag_list)
          redirect_to admin_recipe_path(@recipe.id), notice: "レシピを更新しました。"
        else
          render :edit, alert: "投稿に失敗しました。お手数ですが、入力内容をご確認のうえ再度お試しください。"
        end
     end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to admin_recipes_path, notice: "レシピを削除しました。"
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :is_draft, :menu_image, :original_menu_name, :original_menu_id,
      ingredients_attributes: [:id, :content, :quantity, :_destroy],
      procedures_attributes: [:id, :direction, :image, :_destroy] ,
      original_menu_attributes: [:name]
      )
  end

  def tag_params
      params.require(:recipe).permit(:tag_name)
  end

end
