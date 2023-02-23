class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_one_attached :profile_image
  

    validates :name, presence: true
    validates :email, presence: true

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :favorited_posts, through: :likes, source: :post
    
    #フォロー・フォロワー機能
    has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    
    has_many :followings, through: :relationships, source: :followed
    has_many :followers, through: :reverse_of_relationships, source: :follower
    
  # ゲストサインイン用 
  def self.guest
    find_or_create_by!(email: 'test_user@test.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
      user.name = 'テストユーザー'
      user.introduction = "テストユーザーの自己紹介文です"
    end
  end
    
  #プロフィール画像が見つからない場合はnoimageを表示する
  #プロフィール画像を任意の画像サイズで出力出来るように
  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path),filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit:[width,height]).processed
  end
  
  #いいねしているかチェック
  def favorited_by?(post_id)
    favorites.where(post_id: post_id).exists?
  end
    

end
