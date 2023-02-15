class Public::PostsController < ApplicationController
  
  def index
    @posts = Post.all.order(created_at: "DESC")
    @tags=Tag.all
  end

  def show
    @post = Post.find(params[:id])
    # @post_comment=PostComment.new
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
    @post = Post.new(post_params)#Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:name].split(' ')
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
        redirect_to post_path(@post.id),notice:"投稿しました"
      else
        flash.now[:alert] = "エラーです"
        render :new
      end
    else
      flash.now[:alert] = "マップ上をクリックして下さい"
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @lat = @post.map.latitude
    @lng = @post.map.longitude
    gon.lat = @lat
    gon.lng = @lng
    @tag_list=@post.tags.pluck(:name).join(' ')
  end
  
  def update
    @post = Post.find(params[:id])
    tag_list=params[:post][:name].split(' ')
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
       @old_relations=PostTag.where(post_id: @post.id)
        @old_relations.each do |relation|
          relation.delete
        end         
       @post.save_tag(tag_list)
       redirect_to post_path(@post.id),notice:'更新しました'
    else
      redirect_to request.referer
    end
  end
  
  def destroy
  end
  
  def map
    @maps = Map.all
    gon.maps = Map.all
    @posts = Post.all
    gon.posts = Post.all
  end

  def ranking
  end

  def search
    @posts = Post.search(params[:keyword])
  end
  
  
  private
  
  def post_params
    params.require(:post).permit(:title, :caption, :post_image, map_attributes:[:id, :address, :latitude, :longitude] )
  end
  
end
