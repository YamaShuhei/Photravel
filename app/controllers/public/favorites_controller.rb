# frozen_string_literal: true

class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :post_params, only: [:create, :destroy]

  def create
    Favorite.create(user_id: current_user.id, post_id: @post.id)
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, post_id: @post.id)
    favorite.destroy
  end

  private
    def post_params
      @post = Post.find(params[:post_id])
    end
end
