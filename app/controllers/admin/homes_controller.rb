class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  
  def top
    @posts = Post.order(created_at: "DESC").page(params[:page])
  end
  
  
private
  
end



  