class UserListing < ApplicationRecord
  belongs_to :user
  belongs_to :listing, optional: true

  validates :url, presence: true
  validates :url, format: { with: %r{\Ahttps://www\.airbnb}, message: 'is not a valid Airbnb URL.' }

  has_many :reviews, through: :listing
end
