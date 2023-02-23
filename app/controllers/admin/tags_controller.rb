class Admin::TagsController < ApplicationController
  
  def index
    @tags = Tag.all.order(created_at: "DESC").page(params[:page])
  end
  
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to request.referer, notice: "タグを削除しました"
  end
  
end
