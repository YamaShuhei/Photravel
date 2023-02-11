class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :post_image
  
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_one :map, dependent: :destroy
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
end
