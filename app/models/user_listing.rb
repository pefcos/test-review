class UserListing < ApplicationRecord
  belongs_to :user
  belongs_to :listing, optional: true

  has_many :reviews, through: :listing
end
