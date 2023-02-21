class Public::CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      render :post_comments
      flash.now[:notice] = "コメントしました"
    else
      render :error
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    flash.now[:alert] = "投稿を削除しました"
    @post = Post.find(params[:post_id])
    render :post_comments
  end
  
  private
  
  
  def comment_params
    params.require(:comment).permit(:comment)
  end
end

