class Post < ApplicationRecord
  belongs_to :user
  
  has_one_attached :post_image
  
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_tags,dependent: :destroy
  has_many :tags,through: :post_tags
  
  has_one :map, dependent: :destroy
  
  #プロフィール画像を任意の画像サイズで出力出来るように
  def get_post_image(width,height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      post_image.attach(io: File.open(file_path),filename: 'no-postimage.jpg', content_type: 'image/jpeg')
    end
    post_image.variant(resize_to_limit:[width,height]).processed
  end
  
  #タグ保存用
  def save_tag(sent_tags)
    # タグ(name)を配列として取得（空白でなければ）
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてold_tagsに代入
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags
    
    #タグの削除と保存
    old_tags.each do |old|
      self.tags.delete　Tag.find_by(name: old)
    end
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
   end
  end
  
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
end
