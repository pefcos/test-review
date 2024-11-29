class Listing < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :reviews

  validates :url, presence: true
  validates :url, format: { with: /\Ahttps:\/\/www\.airbnb\.com/, message: "is not a valid Airbnb URL." }
end
