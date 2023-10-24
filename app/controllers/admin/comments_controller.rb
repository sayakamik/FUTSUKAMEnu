class Admin::CommentsController < ApplicationController
  def index
    @comments = PostComment.all.page(params[:page])
                .per(15)
                .order("post_comments.created_at DESC")
    @comments_count = PostComment
  end

  def destroy
    @recipe = Recipe.where(is_draft: false).find(params[:recipe_id])
    @post_comment = PostComment.find(params[:id])#コメントidの取り方？
    post_comment = @recipe.post_comments.find(params[:id])
    post_comment.destroy
    # app/views/post_comments/destroy.js.erbを参照する
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end
