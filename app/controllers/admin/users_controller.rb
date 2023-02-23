class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @user = User.find(params[:id])
    @post = Post.where(user_id: @user.id).order('created_at desc')
    user_id = @user.id
    @fav_post = Post.find(Favorite.where(user_id: user_id).order('created_at desc').pluck(:post_id))
  end
  
  def index
    @users = User.all.page(params[:page])
    
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "ユーザーを削除しました"
  end

end
