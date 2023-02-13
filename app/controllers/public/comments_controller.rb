class Public::CommentsController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      redirect_to post_path(@post),notice:"コメントしました"
    else
      redirect_to request.referer,notice:"コメントに失敗しました"
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to request.referer,notice:"コメントを削除しました"
    
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:comment)
  end
end

