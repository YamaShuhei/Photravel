class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = Post.all
    @post = Post.find_by(user_id: @user.id)
  end

  def edit
    @user = User.find(params[:id])
    
  end
  
  def update
    
  end 
end
