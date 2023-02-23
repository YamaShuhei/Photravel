# frozen_string_literal: true

class Public::HomesController < ApplicationController
  def top
    @posts = Post.all.order(created_at: "DESC").limit(10)
    @month_favorite_ranks = Post.find(Favorite.group(:post_id).where(created_at: Time.current.all_month).order("count(post_id) desc").limit(5).pluck(:post_id))
  end
end
