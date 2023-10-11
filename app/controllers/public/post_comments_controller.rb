class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    @recipe = Recipe.where(is_draft: false).find(params[:recipe_id])
    @post_comment = PostComment.new(post_comment_params)
    @post_comment.recipe_id = @recipe.id
    @post_comment.user_id = current_user.id
    @post_comment.save
    # app/views/post_comments/create.js.erbを参照する
    redirect_to recipe_path(params[:recipe_id])
  end

  def destroy
    @recipe = Recipe.where(is_draft: false).find(params[:recipe_id])
    @post_comment = PostComment.find(params[:id])
    post_comment = @recipe.post_comments.find(params[:id])
    post_comment.destroy
    # app/views/post_comments/destroy.js.erbを参照する
    redirect_to recipe_path(params[:recipe_id])

  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end
