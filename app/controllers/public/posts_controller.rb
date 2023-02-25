# frozen_string_literal: true

class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy]
  before_action :is_matching_login_user, only: [:destroy, :edit, :update]

  def index
    @posts = Post.all.order(created_at: "DESC").page(params[:page]).per(15)
    @tags = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @post_tags = @post.tags
    @lat = @post.map.latitude
    @lng = @post.map.longitude
    gon.lat = @lat
    gon.lng = @lng
    @comments = @post.comments
    if user_signed_in?
      @comment = current_user.comments.new
    end
  end

  def show_detail
    @post = Post.find(params[:post_id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params) # Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:name].split(" ")
    latitude = params[:post][:map][:latitude]
    longitude = params[:post][:map][:longitude]
    address = params[:post][:map][:address]
    unless latitude.empty? && longitude.empty?
      if @post.save
        @map = @post.build_map(
          latitude: latitude,
          longitude: longitude,
          address: address
        )

        @map.save
        # タグ保存
        @post.save_tag(tag_list)
        redirect_to post_path(@post.id), notice: "投稿しました"
      else
        flash.now[:alert] = "エラーです"
        @post = Post.new(post_params)
        render :new
      end
    else
      flash.now[:alert] = "マップ上をクリックして下さい"
      @post = Post.new(post_params)
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @lat = @post.map.latitude
    @lng = @post.map.longitude
    @map = @post.map
    gon.lat = @lat
    gon.lng = @lng
    @tag_list = @post.tags.pluck(:name).join(" ")
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(" ")
    if @post.update(post_params)
      latitude = params[:post][:map][:latitude]
      longitude = params[:post][:map][:longitude]
      address = params[:post][:map][:address]
      unless latitude.empty? && longitude.empty?
        @map = @post.map.update(
          latitude: latitude,
          longitude: longitude,
          address: address
        )
      end
      @old_relations = PostTag.where(post_id: @post.id)
      @old_relations.each do |relation|
        relation.delete
      end
      @post.save_tag(tag_list)
      redirect_to post_path(@post.id), notice: "更新しました"
    else
      @post = Post.find(params[:id])
      @lat = @post.map.latitude
      @lng = @post.map.longitude
      gon.lat = @lat
      gon.lng = @lng
      @tag_list = @post.tags.pluck(:name).join(" ")
      flash.now[:alert] = "エラーです、内容を確認して下さい"
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user.id)
  end

  def map
    @maps = Map.all
    gon.maps = Map.all
    @post_urls = Post.all.with_attached_post_image
    @post_urls = @post_urls.map { |image_url| image_url.as_json.merge({ image_url: url_for(image_url.post_image) }) }
    gon.posts = @post_urls
    gon.users = User.all
  end

  def search
    @post_counts = Post.search(params[:keyword])
    @posts = Post.search(params[:keyword]).page(params[:page]).order(created_at: "DESC")
  end


  private
    def post_params
      params.require(:post).permit(:title, :caption, :post_image, map_attributes: [:id, :address, :latitude, :longitude])
    end

    def is_matching_login_user
      @post = Post.find(params[:id])
      user_id = @post.user_id
      unless user_id == current_user.id
        redirect_to posts_path
      end
    end
end
