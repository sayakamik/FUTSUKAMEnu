class Admin::CommentsController < ApplicationController
  def index
    @comments = PostComment.all.page(params[:page]).per(15)
    @comments_count = @comments.all
  end
end
