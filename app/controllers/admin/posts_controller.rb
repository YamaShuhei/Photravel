# frozen_string_literal: true

class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def show
    @post = Post.find(params[:id])
    @post_tags = @post.tags
    @lat = @post.map.latitude
    @lng = @post.map.longitude
    gon.lat = @lat
    gon.lng = @lng
    @comments = @post.comments
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_root_path, notice: "投稿の削除が完了しました"
  end
end
