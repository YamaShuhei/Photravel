class Public::PostsController < ApplicationController
  def index
    @posts = Post.all
    @tags=Tag.all
  end

  def show
    @post = Post.find(params[:id])
    # @post_comment=PostComment.new
    @post_tags = @post.tags
  end

  def new
    @post = Post.new
    GOOGLE_MAP_API=ENV["GOOGLE_API_KEY"]
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:name].split(' ')
    
    if @post.save
      @post.save_tag(tag_list)
      redirect_to post_path(@post.id),notice:"投稿しました"
    else
      redirect_to request.referer
    end
    
  end

  def edit
    
    @post = Post.find(params[:id])
    # pluckはmapと同じ意味です！！
    @tag_list=@post.tags.pluck(:name).join(' ')
  end
  
  def update
    @post = Post.find(params[:id])
    tag_list=params[:post][:name].split(' ')
    if @post.update(post_params)
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

  def ranking
  end

  def search
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :caption, :post_image )
  end
  
end
