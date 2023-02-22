class Public::UsersController < ApplicationController
  before_action :authenticate_user! , only:[:edit, :update]
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @post = Post.where(user_id: @user.id).order('created_at desc').page(params[:page]).per(10)
    user_id = @user.id
    @fav_post = Post.find(Favorite.where(user_id: user_id).order('created_at desc').pluck(:post_id))
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
  if @user.update(user_params)
    flash[:notice] = "登録情報の更新を完了しました"
    redirect_to user_path(@user.id)
  else
    flash[:alert] = "登録情報の更新に失敗しました"
    @user = User.find(params[:id])
    render :edit
  end
  end

  
  private
  
  def user_params
    params.require(:user).permit(:email,:name,:introduction,:profile_image)
  end
  
  def is_matching_login_user
    user_id = params[:id].to_i
    unless user_id == current_user.id
      redirect_to posts_path
    end
  end
  
end
