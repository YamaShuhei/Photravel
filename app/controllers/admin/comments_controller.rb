class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
    
  def destroy
    Comment.find(params[:id]).destroy
    flash.now[:alert] = "投稿を管理者削除しました"
    @post = Post.find(params[:post_id])
    render :post_comments
  end
  
end
