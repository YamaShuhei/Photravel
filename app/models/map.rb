class Map < ApplicationRecord
  belongs_to :post
  geocoded_by :address
  
  after_validation :geocode
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :address, presence: true
end
